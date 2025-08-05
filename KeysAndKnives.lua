local rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local window = rayfield:CreateWindow({
   Name = "Keys and Knifes Script By Bananas",
   LoadingTitle = "Loading...",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = true,
      Invite = "PQvfYaQW68",
      RememberJoins = true
   },
   KeySystem = false
})

local playertab = window:CreateTab("Player", 4483362458)
local gametab = window:CreateTab("Game", 4483345998)
local misctab = window:CreateTab("Misc", 4483362458)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootpart = char:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

player.CharacterAdded:Connect(function(c)
   char = c
   humanoid = c:WaitForChild("Humanoid")
   rootpart = c:WaitForChild("HumanoidRootPart")
end)

local walkspeed = 16
local jumppower = 50
local togglewalk = false
local togglejump = false
local noclip = false
local infjump = false
local noclipconn = nil
local autokill = false
local superman = false
local supermanconn = nil
local supermanvel = nil

local supermangui = Instance.new("ScreenGui")
supermangui.Name = "SupermanControls"
supermangui.Parent = game.CoreGui
supermangui.Enabled = false

local upbutton = Instance.new("TextButton")
upbutton.Size = UDim2.new(0, 60, 0, 60)
upbutton.Position = UDim2.new(1, -130, 1, -130)
upbutton.Text = "↑"
upbutton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
upbutton.TextColor3 = Color3.new(1, 1, 1)
upbutton.TextScaled = true
upbutton.Parent = supermangui

local downbutton = Instance.new("TextButton")
downbutton.Size = UDim2.new(0, 60, 0, 60)
downbutton.Position = UDim2.new(1, -60, 1, -130)
downbutton.Text = "↓"
downbutton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
downbutton.TextColor3 = Color3.new(1, 1, 1)
downbutton.TextScaled = true
downbutton.Parent = supermangui

local isup = false
local isdown = false

upbutton.MouseButton1Down:Connect(function() isup = true end)
upbutton.MouseButton1Up:Connect(function() isup = false end)
downbutton.MouseButton1Down:Connect(function() isdown = true end)
downbutton.MouseButton1Up:Connect(function() isdown = false end)

local screengui = Instance.new("ScreenGui")
screengui.Name = "CancelAutoKillGui"
screengui.Parent = game.CoreGui
screengui.Enabled = false

local cancelbutton = Instance.new("TextButton")
cancelbutton.Size = UDim2.new(0, 150, 0, 50)
cancelbutton.Position = UDim2.new(0.5, -75, 1, -70)
cancelbutton.Text = "Cancel Auto Kill"
cancelbutton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
cancelbutton.TextColor3 = Color3.new(1, 1, 1)
cancelbutton.TextScaled = true
cancelbutton.Parent = screengui

local movementsec = playertab:CreateSection("Movement")

playertab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   SectionParent = movementsec,
   Callback = function(v)
      walkspeed = v
   end
})

playertab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 1,
   CurrentValue = 50,
   SectionParent = movementsec,
   Callback = function(v)
      jumppower = v
      humanoid.UseJumpPower = true
   end
})

playertab:CreateToggle({
   Name = "Toggle WalkSpeed",
   CurrentValue = false,
   SectionParent = movementsec,
   Callback = function(v)
      togglewalk = v
      if not v then humanoid.WalkSpeed = 16 end
   end
})

playertab:CreateToggle({
   Name = "Toggle JumpPower",
   CurrentValue = false,
   SectionParent = movementsec,
   Callback = function(v)
      togglejump = v
      if not v then humanoid.JumpPower = 50 end
   end
})

playertab:CreateToggle({
   Name = "Superman",
   CurrentValue = false,
   SectionParent = movementsec,
   Callback = function(v)
      superman = v
      supermangui.Enabled = v and uis.TouchEnabled
      if v then
         supermanconn = rs.RenderStepped:Connect(function()
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = false
               end
            end
         end)
      else
         if supermanconn then
            supermanconn:Disconnect()
            supermanconn = nil
         end
         if supermanvel then
            supermanvel:Destroy()
            supermanvel = nil
         end
         if char then
            for _, part in pairs(char:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = true
               end
            end
         end
         isup = false
         isdown = false
      end
   end
})

local exploitssec = playertab:CreateSection("Exploits")

local function setnoclip(state)
   if noclip == state then return end
   noclip = state
   
   if noclip then
      noclipconn = rs.RenderStepped:Connect(function()
         if not char then return end
         for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
               v.CanCollide = false
            end
         end
      end)
   else
      if noclipconn then
         noclipconn:Disconnect()
         noclipconn = nil
      end
      if char then
         for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
               v.CanCollide = true
            end
         end
      end
   end
end

playertab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   SectionParent = exploitssec,
   Callback = function(v)
      setnoclip(v)
   end
})

playertab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   SectionParent = exploitssec,
   Callback = function(v)
      infjump = v
   end
})

uis.JumpRequest:Connect(function()
   if infjump and humanoid then
      humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

rs.Heartbeat:Connect(function()
   if humanoid then
      if togglewalk then humanoid.WalkSpeed = walkspeed end
      if togglejump then
         humanoid.JumpPower = jumppower
         humanoid.UseJumpPower = true
      end
      if superman and char and rootpart then
         local movingvert = isup or isdown or uis:IsKeyDown(Enum.KeyCode.LeftControl) or uis:IsKeyDown(Enum.KeyCode.Space)
         if movingvert then
            if not supermanvel then
               supermanvel = Instance.new("BodyVelocity")
               supermanvel.MaxForce = Vector3.new(0, math.huge, 0)
               supermanvel.Parent = rootpart
            end
            local yvel = (isup or uis:IsKeyDown(Enum.KeyCode.Space)) and 70 or (isdown or uis:IsKeyDown(Enum.KeyCode.LeftControl)) and -70 or 0
            supermanvel.Velocity = Vector3.new(0, yvel, 0)
         else
            if supermanvel then
               supermanvel:Destroy()
               supermanvel = nil
            end
         end
      end
   end
end)

local seekersec = gametab:CreateSection("Seeker Stuff")

gametab:CreateButton({
   Name = "Kill Hider (Auto)",
   SectionParent = seekersec,
   Callback = function()
      local playerdata = player:FindFirstChild("PlayerData")
      local team = playerdata and playerdata:FindFirstChild("Game") and playerdata.Game:FindFirstChild("Team")
      
      if team and team:IsA("StringValue") and team.Value == "Key" then
         rayfield:Notify({
            Title = "Error",
            Content = "You can't auto kill as a hider!",
            Duration = 5,
            Image = 4483362458
         })
         return
      end
      
      task.spawn(function()
         autokill = true
         screengui.Enabled = true
         local function getnearesthider()
            local nearesthider = nil
            local mindist = math.huge
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return nil end
            
            for _, plr in pairs(game.Players:GetPlayers()) do
               if plr ~= player then
                  local data = plr:FindFirstChild("PlayerData")
                  local team = data and data:FindFirstChild("Game") and data.Game:FindFirstChild("Team")
                  if team and team:IsA("StringValue") and team.Value == "Key" and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                     local distance = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                     if distance < mindist then
                        mindist = distance
                        nearesthider = plr
                     end
                  end
               end
            end
            return nearesthider
         end

         local target = getnearesthider()
         if target then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local targethum = target.Character and target.Character:FindFirstChild("Humanoid")
            local targethrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and targethum and targethrp then
               while autokill and targethum.Health > 0 and targethrp.Parent and task.wait(0.1) do
                  hrp.CFrame = targethrp.CFrame * CFrame.new(0, 0, 1)
               end
            end
         end
         autokill = false
         screengui.Enabled = false
      end)
   end
})

cancelbutton.MouseButton1Click:Connect(function()
   if autokill then
      autokill = false
      screengui.Enabled = false
      rayfield:Notify({
         Title = "Auto Kill",
         Content = "Auto kill has been cancelled!",
         Duration = 5,
         Image = 4483362458
      })
   end
end)

local hidersec = gametab:CreateSection("Hider Stuff")
local tpstuds = 100

local function tpstuds(yoffset)
   local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
   if hrp then
      hrp.CFrame = hrp.CFrame + Vector3.new(0, yoffset, 0)
   end
end

gametab:CreateInput({
   Name = "Studs to Teleport",
   SectionParent = hidersec,
   PlaceholderText = "1-150 recommended",
   RemoveTextAfterFocusLost = false,
   Callback = function(txt)
      local num = tonumber(txt)
      if num then tpstuds = num end
   end
})

gametab:CreateButton({
   Name = "Teleport Up",
   SectionParent = hidersec,
   Callback = function()
      tpstuds(tpstuds)
   end
})

gametab:CreateButton({
   Name = "Teleport Down",
   SectionParent = hidersec,
   Callback = function()
      tpstuds(-tpstuds)
   end
})

gametab:CreateButton({
   Name = "Teleport to Exit Door",
   SectionParent = hidersec,
   Callback = function()
      local part = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("ExitZone") and workspace.Game.ExitZone:FindFirstChild("EscapePart")
      if part and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         player.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
      end
   end
})

local espsec = gametab:CreateSection("ESPs")
local playeresp = false
local crateesp = false
local exitesp = false
local esphighlights = {}
local cratehighlights = {}
local exitespobj = nil
local espconn = nil

local function clearhighlights()
   for _, h in pairs(esphighlights) do
      if h and h.Adornee then h:Destroy() end
   end
   table.clear(esphighlights)
end

local function clearcratehighlights()
   for _, h in pairs(cratehighlights) do
      if h and h.Adornee then h:Destroy() end
   end
   table.clear(cratehighlights)
end

local function updateesp()
   if not playeresp then
      clearhighlights()
      return
   end
   clearhighlights()
   for _, plr in pairs(game.Players:GetPlayers()) do
      if plr == player then continue end
      local char = plr.Character
      local data = plr:FindFirstChild("PlayerData")
      local team = data and data:FindFirstChild("Game") and data.Game:FindFirstChild("Team")
      if char and team and team:IsA("StringValue") and team.Value then
         local color = team.Value == "Key" and Color3.fromRGB(0, 170, 255) or team.Value == "Knife" and Color3.fromRGB(255, 0, 0)
         if color then
            local h = Instance.new("Highlight")
            h.FillColor = color
            h.OutlineColor = Color3.new(1, 1, 1)
            h.FillTransparency = 0.25
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Adornee = char
            h.Parent = game.CoreGui
            table.insert(esphighlights, h)
         end
      end
   end
end

local function updatecrateesp()
   clearcratehighlights()
   if not crateesp then return end
   local crates = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("Game") and workspace.Game.Map.Game:FindFirstChild("Interactions") and workspace.Game.Map.Game.Interactions:FindFirstChild("Crates")
   if crates then
      for _, crate in pairs(crates:GetChildren()) do
         local h = Instance.new("Highlight")
         h.FillColor = Color3.fromRGB(255, 105, 180)
         h.FillTransparency = 0
         h.OutlineColor = Color3.fromRGB(255, 105, 180)
         h.OutlineTransparency = 0
         h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
         h.Adornee = crate
         h.Parent = game.CoreGui
         table.insert(cratehighlights, h)
      end
   end
end

local function updateexitesp()
   if exitespobj and exitespobj.Adornee then exitespobj:Destroy() end
   exitespobj = nil
   if not exitesp then return end
   local part = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("ExitZone") and workspace.Game.ExitZone:FindFirstChild("EscapePart")
   if part then
      exitespobj = Instance.new("Highlight")
      exitespobj.Name = "ExitESP"
      exitespobj.FillColor = Color3.fromRGB(255, 215, 0)
      exitespobj.OutlineColor = Color3.new(1, 1, 1)
      exitespobj.FillTransparency = 0.1
      exitespobj.OutlineTransparency = 0
      exitespobj.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      exitespobj.Adornee = part
      exitespobj.Parent = game.CoreGui
   end
end

gametab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   SectionParent = espsec,
   Callback = function(v)
      playeresp = v
      if not v then
         clearhighlights()
         if espconn then
            espconn:Disconnect()
            espconn = nil
         end
      else
         if not espconn then
            espconn = game.Players.PlayerAdded:Connect(updateesp)
            game.Players.PlayerRemoving:Connect(updateesp)
            updateesp()
         end
      end
   end
})

gametab:CreateToggle({
   Name = "Crate ESP",
   CurrentValue = false,
   SectionParent = espsec,
   Callback = function(v)
      crateesp = v
      updatecrateesp()
   end
})

gametab:CreateToggle({
   Name = "Exit Door ESP",
   CurrentValue = false,
   SectionParent = espsec,
   Callback = function(v)
      exitesp = v
      updateexitesp()
   end
})

task.spawn(function()
   local lastexitupdate = 0
   while true do
      if playeresp then pcall(updateesp) end
      if crateesp then pcall(updatecrateesp) end
      if exitesp and tick() - lastexitupdate >= 5 then
         pcall(updateexitesp)
         lastexitupdate = tick()
      end
      task.wait(5)
   end
end)

local miscsec = misctab:CreateSection("Utilities")

misctab:CreateButton({
   Name = "Inject Infinite Yield",
   SectionParent = miscsec,
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
   end
})

misctab:CreateButton({
   Name = "Inject Dex Explorer",
   SectionParent = miscsec,
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/BigBoyTimme/New.Loadstring.Scripts/refs/heads/main/Dex.Explorer", true))()
   end
})
