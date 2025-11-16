const storageKey = 'studyStudioUsers';
let users = JSON.parse(localStorage.getItem(storageKey) || '{}');
let currentUser = null;
let timerInterval = null;
let timerSeconds = 25 * 60;
let timerMode = 'pomodoro';
let timerConfig = {
  pomodoro: { focus: 25, break: 5 },
  deep: { focus: 50, break: 10 },
  sprint: { focus: 15, break: 5 },
  custom: { focus: 30, break: 5 },
};

const qs = (sel) => document.querySelector(sel);
const qsa = (sel) => Array.from(document.querySelectorAll(sel));

const elements = {
  authPanel: qs('#authPanel'),
  dashboard: qs('#dashboard'),
  loginForm: qs('#loginForm'),
  registerForm: qs('#registerForm'),
  logoutBtn: qs('#logoutBtn'),
  themeSelect: qs('#themeSelect'),
  accentColor: qs('#accentColor'),
  taskForm: qs('#taskForm'),
  taskList: qs('#taskList'),
  taskSummary: qs('#taskSummary'),
  taskProgress: qs('#taskProgress'),
  plannerForm: qs('#plannerForm'),
  plannerList: qs('#plannerList'),
  plannerSummary: qs('#plannerSummary'),
  clearPlanner: qs('#clearPlanner'),
  eventForm: qs('#eventForm'),
  eventList: qs('#eventList'),
  eventSummary: qs('#eventSummary'),
  calendar: qs('#calendar'),
  monthLabel: qs('#monthLabel'),
  prevMonth: qs('#prevMonth'),
  nextMonth: qs('#nextMonth'),
  timerDisplay: qs('#timerDisplay'),
  timerModeLabel: qs('#timerModeLabel'),
  timerStatus: qs('#timerStatus'),
  startTimer: qs('#startTimer'),
  pauseTimer: qs('#pauseTimer'),
  resetTimer: qs('#resetTimer'),
  timerPresets: qsa('.timer-presets .chip'),
  customTime: qs('#customTime'),
};

function saveUsers() {
  localStorage.setItem(storageKey, JSON.stringify(users));
}

function setAccent(color) {
  document.documentElement.style.setProperty('--accent', color);
  if (currentUser) {
    users[currentUser].accent = color;
    saveUsers();
  }
}

function switchTheme(theme) {
  document.body.classList.remove('theme-light', 'theme-dark', 'theme-forest', 'theme-ocean');
  document.body.classList.add(theme);
  if (currentUser) {
    users[currentUser].theme = theme;
    saveUsers();
  }
}

function setLoggedIn(user) {
  currentUser = user;
  elements.authPanel.hidden = !!user;
  elements.dashboard.hidden = !user;
  elements.logoutBtn.style.display = user ? 'inline-flex' : 'none';
  if (user) {
    localStorage.setItem('studyStudioLastUser', user);
  } else {
    localStorage.removeItem('studyStudioLastUser');
  }
  if (user) {
    loadUserData();
  }
}

function hashPassword(pwd) {
  return btoa(pwd).split('').reverse().join('');
}

function ensureUser(username, password, creating = false) {
  const existing = users[username];
  if (creating) {
    if (existing) throw new Error('Username already exists');
    users[username] = {
      password: hashPassword(password),
      theme: 'theme-light',
      accent: '#8a7ff0',
      tasks: [],
      planner: [],
      events: [],
    };
    saveUsers();
    return true;
  }

  if (!existing || existing.password !== hashPassword(password)) {
    throw new Error('Invalid credentials');
  }
  return true;
}

function serializeForm(form) {
  return Object.fromEntries(new FormData(form).entries());
}

function renderTasks() {
  const tasks = users[currentUser].tasks;
  elements.taskList.innerHTML = '';
  tasks.forEach((task) => {
    const li = document.createElement('li');
    const row = document.createElement('div');
    row.className = 'check-row';

    const left = document.createElement('div');
    left.style.display = 'flex';
    left.style.gap = '10px';
    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.checked = task.done;
    checkbox.addEventListener('change', () => {
      task.done = checkbox.checked;
      saveUsers();
      renderTasks();
    });

    const content = document.createElement('div');
    content.innerHTML = `<strong>${task.text}</strong><br><span class="muted">${task.due || 'Flexible'}</span>`;

    left.append(checkbox, content);
    row.append(left);

    const right = document.createElement('div');
    right.className = 'meta';
    if (task.tag) {
      const tag = document.createElement('span');
      tag.className = 'tag';
      tag.textContent = task.tag;
      right.appendChild(tag);
    }
    const remove = document.createElement('button');
    remove.className = 'ghost small';
    remove.textContent = '✕';
    remove.addEventListener('click', () => {
      users[currentUser].tasks = tasks.filter((t) => t.id !== task.id);
      saveUsers();
      renderTasks();
    });

    right.append(remove);
    row.append(right);
    li.append(row);
    elements.taskList.append(li);
  });

  const total = tasks.length || 1;
  const done = tasks.filter((t) => t.done).length;
  const percent = Math.round((done / total) * 100);
  elements.taskProgress.style.width = `${percent}%`;
  elements.taskSummary.textContent = `${done} / ${tasks.length || 0} tasks done`;
}

function renderPlanner() {
  const planner = users[currentUser].planner;
  elements.plannerList.innerHTML = '';
  planner.forEach((session) => {
    const li = document.createElement('li');
    const header = document.createElement('div');
    header.className = 'check-row';
    header.innerHTML = `<div><strong>${session.title}</strong><div class="muted">${session.slot}</div></div>`;
    const intent = document.createElement('div');
    intent.className = 'meta';
    if (session.intent) {
      const tag = document.createElement('span');
      tag.className = 'tag';
      tag.textContent = session.intent;
      intent.append(tag);
    }
    const remove = document.createElement('button');
    remove.className = 'ghost small';
    remove.textContent = '✕';
    remove.addEventListener('click', () => {
      users[currentUser].planner = planner.filter((p) => p.id !== session.id);
      saveUsers();
      renderPlanner();
    });
    intent.append(remove);
    header.append(intent);
    li.append(header);
    elements.plannerList.append(li);
  });

  elements.plannerSummary.textContent = `${planner.length} sessions planned`;
}

function renderEvents() {
  const events = users[currentUser].events;
  elements.eventList.innerHTML = '';
  events
    .sort((a, b) => new Date(a.date) - new Date(b.date))
    .forEach((event) => {
      const li = document.createElement('li');
      li.innerHTML = `<div class="check-row"><div><strong>${event.title}</strong><div class="muted">${event.date}</div></div><div class="meta">${event.notes || ''}</div></div>`;
      elements.eventList.append(li);
    });

  elements.eventSummary.textContent = `${events.length} calendar events`;
  buildCalendar();
}

let currentMonth = new Date();

function buildCalendar() {
  const events = users[currentUser].events;
  const month = currentMonth.getMonth();
  const year = currentMonth.getFullYear();
  const start = new Date(year, month, 1);
  const end = new Date(year, month + 1, 0);
  elements.monthLabel.textContent = start.toLocaleString('default', { month: 'long', year: 'numeric' });

  const startDay = start.getDay();
  const totalDays = end.getDate();
  elements.calendar.innerHTML = '';

  for (let i = 0; i < startDay; i++) {
    const filler = document.createElement('div');
    elements.calendar.append(filler);
  }

  for (let day = 1; day <= totalDays; day++) {
    const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
    const dayEl = document.createElement('div');
    dayEl.className = 'day';
    const today = new Date();
    if (
      day === today.getDate() &&
      month === today.getMonth() &&
      year === today.getFullYear()
    ) {
      dayEl.classList.add('today');
    }

    const matching = events.filter((e) => e.date === dateStr);
    dayEl.innerHTML = `<div>${day}</div>${matching.length ? '<div class="dot"></div>' : ''}`;
    dayEl.addEventListener('click', () => {
      elements.eventForm.date.value = dateStr;
      elements.eventForm.title.focus();
    });
    elements.calendar.append(dayEl);
  }
}

function startTimer() {
  clearInterval(timerInterval);
  timerInterval = setInterval(() => {
    timerSeconds -= 1;
    if (timerSeconds <= 0) {
      clearInterval(timerInterval);
      timerInterval = null;
      elements.timerStatus.textContent = 'Break time!';
      timerSeconds = timerConfig[timerMode].break * 60;
      renderTimer();
      return;
    }
    renderTimer();
  }, 1000);
  elements.timerStatus.textContent = 'Running';
}

function pauseTimer() {
  clearInterval(timerInterval);
  timerInterval = null;
  elements.timerStatus.textContent = 'Paused';
}

function resetTimer() {
  clearInterval(timerInterval);
  timerInterval = null;
  timerSeconds = timerConfig[timerMode].focus * 60;
  elements.timerStatus.textContent = 'Ready';
  renderTimer();
}

function renderTimer() {
  const minutes = Math.floor(timerSeconds / 60)
    .toString()
    .padStart(2, '0');
  const seconds = (timerSeconds % 60).toString().padStart(2, '0');
  elements.timerDisplay.textContent = `${minutes}:${seconds}`;
  elements.timerModeLabel.textContent =
    timerMode === 'custom' ? 'Custom focus' : timerMode.charAt(0).toUpperCase() + timerMode.slice(1);
  if (currentUser) {
    users[currentUser].timerSeconds = timerSeconds;
    users[currentUser].timerMode = timerMode;
    saveUsers();
  }
}

function loadUserData() {
  const user = users[currentUser];
  switchTheme(user.theme || 'theme-light');
  elements.themeSelect.value = user.theme || 'theme-light';
  setAccent(user.accent || '#8a7ff0');
  elements.accentColor.value = user.accent || '#8a7ff0';

  renderTasks();
  renderPlanner();
  renderEvents();

  timerMode = user.timerMode || 'pomodoro';
  timerSeconds = user.timerSeconds || timerConfig[timerMode].focus * 60;
  renderTimer();
}

function initAuth() {
  elements.loginForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const data = serializeForm(elements.loginForm);
    try {
      ensureUser(data.username.trim(), data.password, false);
      setLoggedIn(data.username.trim());
      elements.loginForm.reset();
    } catch (err) {
      alert(err.message);
    }
  });

  elements.registerForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const data = serializeForm(elements.registerForm);
    try {
      ensureUser(data.username.trim(), data.password, true);
      alert('Account created! You can now login.');
      elements.registerForm.reset();
    } catch (err) {
      alert(err.message);
    }
  });

  elements.logoutBtn.addEventListener('click', () => {
    setLoggedIn(null);
  });
}

function initTasks() {
  elements.taskForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const data = serializeForm(elements.taskForm);
    users[currentUser].tasks.push({
      id: crypto.randomUUID(),
      text: data.text,
      tag: data.tag,
      due: data.due,
      done: false,
    });
    saveUsers();
    elements.taskForm.reset();
    renderTasks();
  });
}

function initPlanner() {
  elements.plannerForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const data = serializeForm(elements.plannerForm);
    users[currentUser].planner.push({
      id: crypto.randomUUID(),
      title: data.title,
      slot: data.slot,
      intent: data.intent,
    });
    saveUsers();
    elements.plannerForm.reset();
    renderPlanner();
  });

  elements.clearPlanner.addEventListener('click', () => {
    users[currentUser].planner = [];
    saveUsers();
    renderPlanner();
  });
}

function initEvents() {
  elements.eventForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const data = serializeForm(elements.eventForm);
    users[currentUser].events.push({
      id: crypto.randomUUID(),
      date: data.date,
      title: data.title,
      notes: data.notes,
    });
    saveUsers();
    elements.eventForm.reset();
    renderEvents();
  });

  elements.prevMonth.addEventListener('click', () => {
    currentMonth = new Date(currentMonth.getFullYear(), currentMonth.getMonth() - 1, 1);
    buildCalendar();
  });

  elements.nextMonth.addEventListener('click', () => {
    currentMonth = new Date(currentMonth.getFullYear(), currentMonth.getMonth() + 1, 1);
    buildCalendar();
  });
}

function initTimer() {
  elements.startTimer.addEventListener('click', startTimer);
  elements.pauseTimer.addEventListener('click', pauseTimer);
  elements.resetTimer.addEventListener('click', resetTimer);

  elements.timerPresets.forEach((btn) => {
    btn.addEventListener('click', () => {
      elements.timerPresets.forEach((b) => b.classList.remove('active'));
      btn.classList.add('active');
      timerMode = btn.dataset.mode;
      if (timerMode === 'custom') {
        elements.customTime.hidden = false;
        const minutes = parseInt(elements.customTime.querySelector('input').value, 10) || 25;
        timerConfig.custom.focus = minutes;
      } else {
        elements.customTime.hidden = true;
      }
      resetTimer();
    });
  });

  elements.customTime.querySelector('input').addEventListener('change', (e) => {
    timerConfig.custom.focus = Math.max(1, Number(e.target.value));
    timerMode = 'custom';
    resetTimer();
  });
}

function initTheme() {
  elements.themeSelect.addEventListener('change', (e) => switchTheme(e.target.value));
  elements.accentColor.addEventListener('input', (e) => setAccent(e.target.value));
}

document.addEventListener('DOMContentLoaded', () => {
  initAuth();
  initTasks();
  initPlanner();
  initEvents();
  initTimer();
  initTheme();

  const lastUser = localStorage.getItem('studyStudioLastUser');
  if (lastUser && users[lastUser]) {
    setLoggedIn(lastUser);
  }
});
