const storageKey = 'studyStudioUsers';
let users = JSON.parse(localStorage.getItem(storageKey) || '{}');
let currentUser = null;
let timerInterval = null;
let timerSeconds = 25 * 60;
let timerMode = 'pomodoro';
let timerPhase = 'focus';
let clockInterval = null;
let timerConfig = {
  pomodoro: { focus: 25, break: 5 },
  deep: { focus: 50, break: 10 },
  sprint: { focus: 15, break: 5 },
  custom: { focus: 30, break: 5 },
};

const defaultHabits = ['Hydrate', 'Stretch', 'Review notes'];

const qs = (sel) => document.querySelector(sel);
const qsa = (sel) => Array.from(document.querySelectorAll(sel));

const elements = {
  authPanel: qs('#authPanel'),
  dashboard: qs('#dashboard'),
  loginForm: qs('#loginForm'),
  registerForm: qs('#registerForm'),
  logoutBtn: qs('#logoutBtn'),
  liveClock: qs('#liveClock'),
  streakPill: qs('#streakPill'),
  themeSelect: qs('#themeSelect'),
  accentColor: qs('#accentColor'),
  taskForm: qs('#taskForm'),
  taskList: qs('#taskList'),
  taskSummary: qs('#taskSummary'),
  taskProgress: qs('#taskProgress'),
  taskFilter: qs('#taskFilter'),
  dueSoonToggle: qs('#dueSoonToggle'),
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
  focusStats: qs('#focusStats'),
  goalLabel: qs('#goalLabel'),
  goalInput: qs('#goalInput'),
  goalProgress: qs('#goalProgress'),
  goalProgressText: qs('#goalProgressText'),
  tabList: qs('#tabList'),
  tabForm: qs('#tabForm'),
  tabNotes: qs('#tabNotes'),
  activeTabLabel: qs('#activeTabLabel'),
  addTab: qs('#addTab'),
  todayList: qs('#todayList'),
  todayCount: qs('#todayCount'),
  habitList: qs('#habitList'),
  resourceForm: qs('#resourceForm'),
  resourceList: qs('#resourceList'),
  clearResources: qs('#clearResources'),
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
    clearInterval(timerInterval);
    timerInterval = null;
    clearInterval(clockInterval);
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
      theme: 'theme-dark',
      accent: '#8a7ff0',
      tasks: [],
      planner: [],
      events: [],
      tabs: [
        {
          id: crypto.randomUUID(),
          title: 'Main',
          notes: '',
        },
      ],
      activeTabId: null,
      focusStats: { totalMinutes: 0, sessions: 0, todayMinutes: 0, todayDate: new Date().toDateString() },
      goalMinutes: 90,
      habits: defaultHabits,
      habitLog: {},
      resources: [],
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
  const filter = (elements.taskFilter?.value || '').toLowerCase();
  const dueSoonOnly = elements.dueSoonToggle?.checked;

  tasks
    .slice()
    .sort((a, b) => {
      const priorityOrder = { high: 0, medium: 1, low: 2 };
      return priorityOrder[a.priority || 'medium'] - priorityOrder[b.priority || 'medium'];
    })
    .filter((task) => {
      const textMatch = `${task.text} ${task.tag || ''}`.toLowerCase().includes(filter);
      if (!dueSoonOnly) return textMatch;
      if (!task.due) return false;
      const daysAway = (new Date(task.due) - new Date()) / (1000 * 60 * 60 * 24);
      return textMatch && daysAway <= 3;
    })
    .forEach((task) => {
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
    const dueSoon = task.due && (new Date(task.due) - new Date()) / (1000 * 60 * 60 * 24) <= 2;
    const dueLabel = task.due ? `${task.due}${dueSoon ? ' • soon' : ''}` : 'Flexible';
    content.innerHTML = `<strong>${task.text}</strong><br><span class="muted">${dueLabel}</span>`;

    left.append(checkbox, content);
    row.append(left);

    const right = document.createElement('div');
    right.className = 'meta';
    const priority = document.createElement('span');
    priority.className = `tag priority-${task.priority || 'medium'}`;
    priority.textContent = task.priority ? `${task.priority} priority` : 'priority';
    right.append(priority);
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
  updateTodayHighlights();
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
  updateTodayHighlights();
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
      if (timerPhase === 'focus') {
        const minutes = timerConfig[timerMode].focus;
        addFocusMinutes(minutes);
        timerPhase = 'break';
        elements.timerStatus.textContent = 'Break time!';
        timerSeconds = timerConfig[timerMode].break * 60;
        renderTimer();
        startTimer();
        return;
      }

      timerPhase = 'focus';
      elements.timerStatus.textContent = 'Cycle complete';
      timerSeconds = timerConfig[timerMode].focus * 60;
      renderTimer();
      return;
    }
    renderTimer();
  }, 1000);
  elements.timerStatus.textContent = timerPhase === 'focus' ? 'Running' : 'On break';
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
  timerPhase = 'focus';
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
    users[currentUser].timerPhase = timerPhase;
    saveUsers();
  }
}

function addFocusMinutes(minutes) {
  const stats = users[currentUser].focusStats || {
    totalMinutes: 0,
    sessions: 0,
    todayMinutes: 0,
    todayDate: new Date().toDateString(),
  };
  const today = new Date().toDateString();
  if (stats.todayDate !== today) {
    stats.todayDate = today;
    stats.todayMinutes = 0;
  }
  stats.totalMinutes += minutes;
  stats.todayMinutes += minutes;
  stats.sessions += 1;
  users[currentUser].focusStats = stats;
  updateGoalProgress();
  updateStreak();
  renderFocusStats();
  saveUsers();
}

function loadUserData() {
  const user = users[currentUser];
  applyDefaults(user);
  switchTheme(user.theme || 'theme-dark');
  elements.themeSelect.value = user.theme || 'theme-dark';
  setAccent(user.accent || '#8a7ff0');
  elements.accentColor.value = user.accent || '#8a7ff0';

  renderTasks();
  renderPlanner();
  renderEvents();

  timerMode = user.timerMode || 'pomodoro';
  timerSeconds = user.timerSeconds || timerConfig[timerMode].focus * 60;
  timerPhase = user.timerPhase || 'focus';
  renderTimer();
  renderTabs();
  renderFocusStats();
  updateGoalProgress();
  renderHabits();
  renderResources();
  updateTodayHighlights();
  updateStreak();
  startClock();
  elements.goalInput.value = user.goalMinutes;
}

function applyDefaults(user) {
  user.theme = user.theme || 'theme-dark';
  user.accent = user.accent || '#8a7ff0';
  user.tabs = user.tabs || [
    { id: crypto.randomUUID(), title: 'Main', notes: '' },
  ];
  user.activeTabId = user.activeTabId || user.tabs[0].id;
  user.focusStats =
    user.focusStats ||
    { totalMinutes: 0, sessions: 0, todayMinutes: 0, todayDate: new Date().toDateString() };
  user.goalMinutes = user.goalMinutes || 90;
  user.habits = user.habits || defaultHabits;
  user.habitLog = user.habitLog || {};
  user.resources = user.resources || [];
  user.tasks = user.tasks || [];
  user.planner = user.planner || [];
  user.events = user.events || [];
  user.streak = user.streak || { count: 0, lastDate: null };
  saveUsers();
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
      priority: data.priority,
      tag: data.tag,
      due: data.due,
      done: false,
    });
    saveUsers();
    elements.taskForm.reset();
    renderTasks();
  });

  elements.taskFilter.addEventListener('input', renderTasks);
  elements.dueSoonToggle.addEventListener('change', renderTasks);
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

  qsa('[data-template]').forEach((btn) => {
    btn.addEventListener('click', () => {
      const template = btn.dataset.template;
      const templates = {
        morning: { title: 'Morning warmup', slot: '07:30 - 08:30', intent: 'Light review' },
        deep: { title: 'Deep work block', slot: '09:00 - 11:00', intent: 'Project push' },
        review: { title: 'Review sprint', slot: '19:00 - 20:00', intent: 'Flashcards' },
      };
      const payload = templates[template];
      if (!payload) return;
      users[currentUser].planner.push({ id: crypto.randomUUID(), ...payload });
      saveUsers();
      renderPlanner();
    });
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

function initGoalsAndHabits() {
  elements.goalInput.addEventListener('change', (e) => {
    users[currentUser].goalMinutes = Math.max(15, Number(e.target.value));
    saveUsers();
    updateGoalProgress();
  });
}

function renderTabs() {
  const user = users[currentUser];
  if (!user.tabs.length) {
    user.tabs.push({ id: crypto.randomUUID(), title: 'Main', notes: '' });
  }
  elements.tabList.innerHTML = '';
  user.tabs.forEach((tab) => {
    const btn = document.createElement('button');
    btn.className = `chip ${tab.id === user.activeTabId ? 'active' : ''}`;
    btn.textContent = tab.title;
    btn.addEventListener('click', () => setActiveTab(tab.id));
    const remove = document.createElement('span');
    remove.textContent = '×';
    remove.className = 'close';
    remove.addEventListener('click', (e) => {
      e.stopPropagation();
      user.tabs = user.tabs.filter((t) => t.id !== tab.id);
      if (user.activeTabId === tab.id && user.tabs[0]) {
        user.activeTabId = user.tabs[0].id;
      }
      saveUsers();
      renderTabs();
    });
    btn.append(remove);
    elements.tabList.append(btn);
  });

  const active = user.tabs.find((t) => t.id === user.activeTabId) || user.tabs[0];
  if (active) {
    elements.activeTabLabel.textContent = active.title;
    elements.tabNotes.value = active.notes || '';
    user.activeTabId = active.id;
  }
  saveUsers();
}

function setActiveTab(id) {
  users[currentUser].activeTabId = id;
  saveUsers();
  renderTabs();
}

function initTabs() {
  elements.tabForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const data = serializeForm(elements.tabForm);
    const newTab = { id: crypto.randomUUID(), title: data.title, notes: '' };
    users[currentUser].tabs.push(newTab);
    users[currentUser].activeTabId = newTab.id;
    saveUsers();
    elements.tabForm.reset();
    renderTabs();
  });

  elements.addTab.addEventListener('click', () => elements.tabForm.requestSubmit());
  elements.tabNotes.addEventListener('input', () => {
    const user = users[currentUser];
    const tab = user.tabs.find((t) => t.id === user.activeTabId);
    if (tab) {
      tab.notes = elements.tabNotes.value;
      saveUsers();
    }
  });
}

function renderFocusStats() {
  const stats = users[currentUser].focusStats;
  const today = new Date().toDateString();
  if (stats.todayDate !== today) {
    stats.todayDate = today;
    stats.todayMinutes = 0;
  }
  elements.focusStats.textContent = `${stats.todayMinutes} min logged • ${stats.sessions} sessions`;
}

function updateGoalProgress() {
  const user = users[currentUser];
  const stats = user.focusStats;
  const today = new Date().toDateString();
  if (stats.todayDate !== today) {
    stats.todayDate = today;
    stats.todayMinutes = 0;
  }
  const target = user.goalMinutes || 90;
  const percent = Math.min(100, Math.round((stats.todayMinutes / target) * 100));
  elements.goalProgress.style.width = `${percent}%`;
  elements.goalProgressText.textContent = `${stats.todayMinutes} / ${target} minutes logged today`;
  elements.goalLabel.textContent = `Goal: ${target} min`;
}

function renderHabits() {
  const user = users[currentUser];
  const today = new Date().toDateString();
  user.habitLog[today] = user.habitLog[today] || {};
  elements.habitList.innerHTML = '';
  user.habits.forEach((habit) => {
    const label = document.createElement('label');
    label.className = 'habit';
    label.textContent = habit;
    const input = document.createElement('input');
    input.type = 'checkbox';
    input.checked = !!user.habitLog[today][habit];
    input.addEventListener('change', () => {
      user.habitLog[today][habit] = input.checked;
      saveUsers();
      updateStreak();
    });
    label.append(input);
    elements.habitList.append(label);
  });
}

function renderResources() {
  const user = users[currentUser];
  elements.resourceList.innerHTML = '';
  user.resources.forEach((res) => {
    const li = document.createElement('li');
    li.innerHTML = `<div class="check-row"><div><strong>${res.title}</strong><div class="muted">${res.url}</div></div><div class="meta"><a href="${res.url}" target="_blank" class="chip">Open</a></div></div>`;
    elements.resourceList.append(li);
  });
}

function initResources() {
  elements.resourceForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const data = serializeForm(elements.resourceForm);
    users[currentUser].resources.push({ id: crypto.randomUUID(), title: data.title, url: data.url });
    saveUsers();
    elements.resourceForm.reset();
    renderResources();
  });

  elements.clearResources.addEventListener('click', () => {
    users[currentUser].resources = [];
    saveUsers();
    renderResources();
  });
}

function updateTodayHighlights() {
  const todayStr = new Date().toISOString().split('T')[0];
  const tasks = users[currentUser].tasks.filter((t) => t.due === todayStr);
  const events = users[currentUser].events.filter((e) => e.date === todayStr);
  const items = [
    ...tasks.map((t) => ({ type: 'Task', title: t.text })),
    ...events.map((e) => ({ type: 'Event', title: e.title })),
  ];
  elements.todayList.innerHTML = '';
  items.forEach((item) => {
    const li = document.createElement('li');
    li.innerHTML = `<div class="check-row"><div><strong>${item.title}</strong><div class="muted">${item.type} today</div></div></div>`;
    elements.todayList.append(li);
  });
  elements.todayCount.textContent = `${items.length} items`;
}

function updateStreak() {
  const user = users[currentUser];
  const today = new Date().toDateString();
  const hasProgress = (user.focusStats?.todayMinutes || 0) > 0 || (user.habitLog?.[today] && Object.values(user.habitLog[today]).some(Boolean));
  user.streak = user.streak || { count: 0, lastDate: null };
  if (user.streak.lastDate !== today && hasProgress) {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayStr = yesterday.toDateString();
    const continues = user.streak.lastDate === yesterdayStr;
    user.streak.count = continues ? user.streak.count + 1 : 1;
    user.streak.lastDate = today;
    saveUsers();
  }
  elements.streakPill.textContent = `${user.streak.count || 0} day streak`;
}

function startClock() {
  if (clockInterval) clearInterval(clockInterval);
  const update = () => {
    const now = new Date();
    const hours = now.getHours();
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const ampm = hours >= 12 ? 'PM' : 'AM';
    const display = `${((hours + 11) % 12) + 1}:${minutes} ${ampm}`;
    elements.liveClock.textContent = display;
  };
  update();
  clockInterval = setInterval(update, 1000);
}

document.addEventListener('DOMContentLoaded', () => {
  initAuth();
  initTasks();
  initPlanner();
  initEvents();
  initTimer();
  initTheme();
  initTabs();
  initResources();
  initGoalsAndHabits();

  const lastUser = localStorage.getItem('studyStudioLastUser');
  if (lastUser && users[lastUser]) {
    setLoggedIn(lastUser);
  }
});
