local v0 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))();
local v1 = v0:CreateWindow({Name="Keys and Knifes Script By Bananas",LoadingTitle="Loading...",ConfigurationSaving={Enabled=false},Discord={Enabled=true,Invite="PQvfYaQW68",RememberJoins=true},KeySystem=true,KeySettings={Title="Keys and Knifes Script",Subtitle="Key System",Note="Join Discord for key: https://discord.gg/PQvfYaQW68",Key="Bananas",SaveKey=false,GrabKeyFromSite=false}});
local v2 = v1:CreateTab("Player", (4933589872 - 0) - 450227414);
local v3 = v1:CreateTab("Game", 4483346505 - (114 + 175 + 218));
local v4 = v1:CreateTab("Misc", (4392997927 - -90365875) - ((2960 - (760 + 987)) + (2044 - (1789 + 124))));
local v5 = game.Players.LocalPlayer;
local v6 = v5.Character or v5.CharacterAdded:Wait();
local v7 = v6:WaitForChild("Humanoid");
local v8 = v6:WaitForChild("HumanoidRootPart");
local v9 = game:GetService("RunService");
local v10 = game:GetService("UserInputService");
v5.CharacterAdded:Connect(function(v53)
	local v54 = 0;
	while true do
		if (v54 == (766 - (745 + 21))) then
			v6 = v53;
			v7 = v53:WaitForChild("Humanoid");
			v54 = 1 + 0;
		end
		if (v54 == (2 - 1)) then
			v8 = v53:WaitForChild("HumanoidRootPart");
			break;
		end
	end
end);
local v11 = 4 + 12;
local v12 = (117 - 87) + 1 + 19;
local v13 = false;
local v14 = false;
local v15 = false;
local v16 = false;
local v17 = nil;
local v18 = false;
local v19 = Instance.new("ScreenGui");
v19.Name = "CancelAutoKillGui";
v19.Parent = game.CoreGui;
v19.Enabled = false;
local v24 = Instance.new("TextButton");
v24.Size = UDim2.new(0 - (0 + 0), (1587 - (87 + 968)) - (1681 - 1299), 0 + 0, (2054 - 1145) - ((2227 - (447 + 966)) + (123 - 78)));
v24.Position = UDim2.new(0.5 - 0, -((1828 - (1703 + 114)) + 64), (702 - (376 + 325)) + 0, -((8 - 3) + 65));
v24.Text = "Cancel Auto Kill";
v24.BackgroundColor3 = Color3.fromRGB((279 - 188) + 164, (253 + 632) - ((574 - 313) + 624), (14 - (9 + 5)) - 0);
v24.TextColor3 = Color3.new(1081 - ((1396 - (85 + 291)) + (1325 - (243 + 1022))), (5418 - 3994) - (630 + 793), 3 - (2 + 0));
v24.TextScaled = true;
v24.Parent = v19;
local v32 = v2:CreateSection("Movement");
v2:CreateSlider({Name="WalkSpeed",Range={((249 + 57) - ((314 - (163 + 91)) + (2160 - (1869 + 61)))),(56 + 144)},Increment=((3 - 2) + (0 - 0)),CurrentValue=(2 + 2 + 12),SectionParent=v32,Callback=function(v55)
	v11 = v55;
end});
v2:CreateSlider({Name="JumpPower",Range={((1688 + 109) - (760 + (2461 - (1329 + 145)))),((1835 - (140 + 831)) - (2414 - (1409 + 441)))},Increment=(1914 - (1789 + (842 - (15 + 703)))),CurrentValue=(816 - (346 + 399 + (459 - (262 + 176)))),SectionParent=v32,Callback=function(v56)
	v12 = v56;
	v7.UseJumpPower = true;
end});
v2:CreateToggle({Name="Toggle WalkSpeed",CurrentValue=false,SectionParent=v32,Callback=function(v58)
	v13 = v58;
	if not v58 then
		v7.WalkSpeed = (1727 - (345 + 1376)) + (698 - (198 + 490));
	end
end});
v2:CreateToggle({Name="Toggle JumpPower",CurrentValue=false,SectionParent=v32,Callback=function(v59)
	v14 = v59;
	if not v59 then
		v7.JumpPower = 137 - (384 - 297);
	end
end});
local v33 = v2:CreateSection("Exploits");
local function v34(v60)
	local v61 = (0 - 0) - 0;
	while true do
		if (v61 == ((1207 - (696 + 510)) + (0 - 0))) then
			if v15 then
				v17 = v9.RenderStepped:Connect(function()
					local v120 = 1262 - (1091 + 171);
					while true do
						if (v120 == (0 + 0)) then
							if not v6 then
								return;
							end
							for v156, v157 in pairs(v6:GetDescendants()) do
								if v157:IsA("BasePart") then
									v157.CanCollide = false;
								end
							end
							break;
						end
					end
				end);
			else
				local v112 = 0;
				local v113;
				while true do
					if (v112 == 0) then
						v113 = (0 - 0) + (0 - 0);
						while true do
							if (v113 == ((374 - (123 + 251)) + 0)) then
								if v17 then
									v17:Disconnect();
									v17 = nil;
								end
								if v6 then
									for v177, v178 in pairs(v6:GetDescendants()) do
										if v178:IsA("BasePart") then
											v178.CanCollide = true;
										end
									end
								end
								break;
							end
						end
						break;
					end
				end
			end
			break;
		end
		if (v61 == ((5242 - 4187) - ((785 - (208 + 490)) + 82 + 886))) then
			if (v15 == v60) then
				return;
			end
			v15 = v60;
			v61 = 1 + 0 + (836 - (660 + 176));
		end
	end
end
v2:CreateToggle({Name="NoClip",CurrentValue=false,SectionParent=v33,Callback=function(v62)
	v34(v62);
end});
v2:CreateToggle({Name="Infinite Jump",CurrentValue=false,SectionParent=v33,Callback=function(v63)
	v16 = v63;
end});
v10.JumpRequest:Connect(function()
	if (v16 and v7) then
		v7:ChangeState(Enum.HumanoidStateType.Jumping);
	end
end);
v9.Heartbeat:Connect(function()
	if v7 then
		local v98 = (0 + 0) - 0;
		while true do
			if (v98 == 0) then
				if v13 then
					v7.WalkSpeed = v11;
				end
				if v14 then
					local v127 = 202 - (14 + 188);
					while true do
						if (v127 == ((675 - (534 + 141)) + 0 + 0)) then
							v7.JumpPower = v12;
							v7.UseJumpPower = true;
							break;
						end
					end
				end
				break;
			end
		end
	end
end);
local v35 = v3:CreateSection("Seeker Stuff");
v3:CreateButton({Name="Kill Hider (Auto)",SectionParent=v35,Callback=function()
	local v64 = v5:FindFirstChild("PlayerData");
	local v65 = v64 and v64:FindFirstChild("Game") and v64.Game:FindFirstChild("Team");
	if (v65 and v65:IsA("StringValue") and (v65.Value == "Key")) then
		local v99 = 0 + 0;
		local v100;
		while true do
			if (v99 == (0 + 0)) then
				v100 = (2282 - 1196) - ((731 - 270) + (1753 - 1128));
				while true do
					if (v100 == (0 - 0)) then
						local v135 = 0 + 0;
						while true do
							if (v135 == (0 + 0)) then
								v0:Notify({Title="Error",Content="You can't auto kill as a hider!",Duration=((1814 - (115 + 281)) - ((1039 - 592) + 800 + 166)),Image=((4483362458 - 0) - (0 - 0))});
								return;
							end
						end
					end
				end
				break;
			end
		end
	end
	task.spawn(function()
		local v93 = (867 - (550 + 317)) + (0 - 0);
		local v94;
		local v95;
		while true do
			if (v93 == (1817 - ((2393 - 690) + (318 - 204)))) then
				v18 = true;
				v19.Enabled = true;
				v93 = (987 - (134 + 151)) - ((2041 - (970 + 695)) + (620 - 295));
			end
			if (((1991 - (582 + 1408)) - 0) == v93) then
				v94 = nil;
				function v94()
					local v114 = nil;
					local v115 = math.huge;
					local v116 = v5.Character and v5.Character:FindFirstChild("HumanoidRootPart");
					if not v116 then
						return nil;
					end
					for v121, v122 in pairs(game.Players:GetPlayers()) do
						if (v122 ~= v5) then
							local v136 = (0 - 0) - 0;
							local v137;
							local v138;
							while true do
								if (v136 == (0 - 0)) then
									v137 = v122:FindFirstChild("PlayerData");
									v138 = v137 and v137:FindFirstChild("Game") and v137.Game:FindFirstChild("Team");
									v136 = 1 + 0;
								end
								if (v136 == ((7 - 5) - (1825 - (1195 + 629)))) then
									if (v138 and v138:IsA("StringValue") and (v138.Value == "Key") and v122.Character and v122.Character:FindFirstChild("Humanoid") and v122.Character:FindFirstChild("HumanoidRootPart")) then
										local v176 = (v116.Position - v122.Character.HumanoidRootPart.Position).Magnitude;
										if (v176 < v115) then
											local v179 = 0 - 0;
											local v180;
											while true do
												if (0 == v179) then
													v180 = (255 - (187 + 54)) - (9 + (785 - (162 + 618)));
													while true do
														if (v180 == ((264 + 112) - (57 + 28 + (620 - 329)))) then
															v115 = v176;
															v114 = v122;
															break;
														end
													end
													break;
												end
											end
										end
									end
									break;
								end
							end
						end
					end
					return v114;
				end
				v93 = 1 + (1 - 0);
			end
			if (v93 == ((100 + 1167) - ((1879 - (1373 + 263)) + (2022 - (451 + 549))))) then
				local v105 = 0 + 0;
				while true do
					if (v105 == (0 - 0)) then
						v95 = v94();
						if v95 then
							local v147 = 0;
							local v148;
							local v149;
							local v150;
							local v151;
							while true do
								if ((0 - 0) == v147) then
									v148 = (1384 - (746 + 638)) - (0 + 0);
									v149 = nil;
									v147 = 1 - 0;
								end
								if (2 == v147) then
									while true do
										if (v148 == (0 + 0)) then
											local v181 = 0;
											while true do
												if (v181 == (342 - (218 + 123))) then
													v148 = (2762 - (1535 + 46)) - (1116 + 7 + 9 + 48);
													break;
												end
												if (v181 == 0) then
													v149 = v5.Character and v5.Character:FindFirstChild("HumanoidRootPart");
													v150 = v95.Character and v95.Character:FindFirstChild("Humanoid");
													v181 = 561 - (306 + 254);
												end
											end
										end
										if ((1 + 0 + 0) == v148) then
											v151 = v95.Character and v95.Character:FindFirstChild("HumanoidRootPart");
											if (v149 and v150 and v151) then
												while v18 and (v150.Health > ((3728 - 1828) - ((1573 - (899 + 568)) + 1180 + 614))) and v151.Parent and task.wait(0.1 + 0) do
													v149.CFrame = v151.CFrame * CFrame.new((614 - 360) - ((766 - (268 + 335)) + (381 - (60 + 230))), (2502 - (426 + 146)) - (224 + 1645 + (1517 - (282 + 1174))), 812 - (569 + 242));
												end
											end
											break;
										end
									end
									break;
								end
								if (v147 == 1) then
									v150 = nil;
									v151 = nil;
									v147 = 2;
								end
							end
						end
						v105 = 1;
					end
					if (v105 == (2 - 1)) then
						v93 = 1 + 2;
						break;
					end
				end
			end
			if ((117 - (1 + 3 + 110)) == v93) then
				v18 = false;
				v19.Enabled = false;
				break;
			end
		end
	end);
end});
v24.MouseButton1Click:Connect(function()
	if v18 then
		local v101 = 1024 - (706 + 318);
		while true do
			if (v101 == (0 - (1251 - (721 + 530)))) then
				v18 = false;
				v19.Enabled = false;
				v101 = (1272 - (945 + 326)) - 0;
			end
			if (v101 == ((2 - 1) + 0 + 0)) then
				v0:Notify({Title="Auto Kill",Content="Auto kill has been cancelled!",Duration=((706 - (271 + 429)) - (1 + 0)),Image=(4483362716 - (190 + (1568 - (1408 + 92))))});
				break;
			end
		end
	end
end);
local v36 = v3:CreateSection("Hider Stuff");
local v37 = (1240 - (461 + 625)) - (1342 - (993 + 295));
local function v38(v66)
	local v67 = 0 + 0;
	local v68;
	local v69;
	while true do
		if (v67 == (1172 - (418 + 753))) then
			while true do
				if (v68 == (0 + 0 + 0)) then
					v69 = v5.Character and v5.Character:FindFirstChild("HumanoidRootPart");
					if v69 then
						v69.CFrame = v69.CFrame + Vector3.new(0 + 0, v66, (0 + 0) - (0 + 0));
					end
					break;
				end
			end
			break;
		end
		if (v67 == (529 - (406 + 123))) then
			v68 = (1872 - (1749 + 20)) - (17 + 21 + 65);
			v69 = nil;
			v67 = 1;
		end
	end
end
v3:CreateInput({Name="Studs to Teleport",SectionParent=v36,PlaceholderText="1-150 recommended",RemoveTextAfterFocusLost=false,Callback=function(v70)
	local v71 = (3172 - (1249 + 73)) - (503 + 906 + (1586 - (466 + 679)));
	local v72;
	while true do
		if (v71 == ((1726 - 1008) - ((42 - 27) + (2603 - (106 + 1794))))) then
			v72 = tonumber(v70);
			if v72 then
				v37 = v72;
			end
			break;
		end
	end
end});
v3:CreateButton({Name="Teleport Up",SectionParent=v36,Callback=function()
	v38(v37);
end});
v3:CreateButton({Name="Teleport Down",SectionParent=v36,Callback=function()
	v38(-v37);
end});
v3:CreateButton({Name="Teleport to Exit Door",SectionParent=v36,Callback=function()
	local v73 = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("ExitZone") and workspace.Game.ExitZone:FindFirstChild("EscapePart");
	if (v73 and v5.Character and v5.Character:FindFirstChild("HumanoidRootPart")) then
		v5.Character.HumanoidRootPart.CFrame = v73.CFrame + Vector3.new((53 + 113) - (31 + 91 + 44), 8 - (8 - 5), (0 - 0) + (114 - (4 + 110)));
	end
end});
local v39 = v3:CreateSection("ESPs");
local v40 = false;
local v41 = false;
local v42 = false;
local v43 = {};
local v44 = {};
local v45 = nil;
local v46 = nil;
local function v47()
	local v74 = 0;
	local v75;
	while true do
		if (v74 == (584 - (57 + 527))) then
			v75 = (1865 - (41 + 1386)) - ((365 - (17 + 86)) + 120 + 56);
			while true do
				if (v75 == ((3837 - 2116) - ((999 - 654) + 1376))) then
					for v128, v129 in pairs(v43) do
						if (v129 and v129.Adornee) then
							v129:Destroy();
						end
					end
					table.clear(v43);
					break;
				end
			end
			break;
		end
	end
end
local function v48()
	local v76 = 166 - (122 + 44);
	local v77;
	while true do
		if (v76 == (0 - 0)) then
			v77 = 0 - 0;
			while true do
				if (v77 == ((560 + 128) - (29 + 169 + (992 - 502)))) then
					for v130, v131 in pairs(v44) do
						if (v131 and v131.Adornee) then
							v131:Destroy();
						end
					end
					table.clear(v44);
					break;
				end
			end
			break;
		end
	end
end
local function v49()
	local v78 = 65 - (30 + 35);
	while true do
		if (v78 == (0 + 0)) then
			if not v40 then
				v47();
				return;
			end
			v47();
			v78 = 1258 - (1043 + 214);
		end
		if (v78 == (3 - 2)) then
			for v107, v108 in pairs(game.Players:GetPlayers()) do
				if (v108 == v5) then
					continue;
				end
				local v109 = v108.Character;
				local v110 = v108:FindFirstChild("PlayerData");
				local v111 = v110 and v110:FindFirstChild("Game") and v110.Game:FindFirstChild("Team");
				if (v109 and v111 and v111:IsA("StringValue") and v111.Value) then
					local v123 = 1212 - (323 + 889);
					local v124;
					while true do
						if ((0 - 0) == v123) then
							v124 = ((v111.Value == "Key") and Color3.fromRGB(0 - 0, 407 - (817 - (361 + 219)), (1781 - (53 + 267)) - (696 + 510))) or ((v111.Value == "Knife") and Color3.fromRGB(58 + 197, 1257 - ((1456 - (15 + 398)) + (1196 - (18 + 964))), (0 - 0) - (0 + 0)));
							if v124 then
								local v162 = 0 + 0;
								local v163;
								local v164;
								while true do
									if (v162 == (850 - (20 + 830))) then
										v163 = 1262 - (1091 + 171);
										v164 = nil;
										v162 = 1;
									end
									if (v162 == (1 + 0)) then
										while true do
											if (v163 == ((127 - (116 + 10)) + 0)) then
												local v191 = 0 + 0;
												while true do
													if (v191 == (739 - (542 + 196))) then
														v163 = (18 - 9) - (3 + 4);
														break;
													end
													if (v191 == (0 + 0)) then
														v164.OutlineColor = Color3.new(3 - (1 + 1), (7 - 4) - (4 - 2), (1926 - (1126 + 425)) - (123 + (656 - (118 + 287))));
														v164.FillTransparency = 320.25 - ((207 - 154) + 267);
														v191 = 1122 - (118 + 1003);
													end
												end
											end
											if (v163 == ((2042 - 1344) - ((585 - (142 + 235)) + 490))) then
												local v192 = 0;
												while true do
													if (v192 == (4 - 3)) then
														v163 = 1 + 0 + (977 - (553 + 424));
														break;
													end
													if (v192 == (0 - 0)) then
														v164 = Instance.new("Highlight");
														v164.FillColor = v124;
														v192 = 1 + 0;
													end
												end
											end
											if (v163 == (2 + 0 + 2)) then
												table.insert(v43, v164);
												break;
											end
											if (((489 + 350) - (660 + 75 + 101)) == v163) then
												v164.Adornee = v109;
												v164.Parent = game.CoreGui;
												v163 = 2 + 1 + 1;
											end
											if (v163 == ((2 - 1) + 1)) then
												local v196 = 0 - 0;
												while true do
													if (0 == v196) then
														v164.OutlineTransparency = 850 - ((44 - 24) + 242 + 588);
														v164.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
														v196 = 4 - 3;
													end
													if ((754 - (239 + 514)) == v196) then
														v163 = (72 + 133) - ((1343 - (797 + 532)) + 188);
														break;
													end
												end
											end
										end
										break;
									end
								end
							end
							break;
						end
					end
				end
			end
			break;
		end
	end
end
local function v50()
	local v79 = 0 + 0;
	local v80;
	local v81;
	while true do
		if (0 == v79) then
			v80 = 0 + 0 + (0 - 0);
			v81 = nil;
			v79 = 1;
		end
		if (v79 == 1) then
			while true do
				if (v80 == (1202 - (373 + 829))) then
					local v125 = 731 - (476 + 255);
					while true do
						if (v125 == (1131 - (369 + 761))) then
							v80 = 676 - (309 + 225 + (255 - 114));
							break;
						end
						if (v125 == (0 - 0)) then
							v48();
							if not v41 then
								return;
							end
							v125 = 239 - (64 + 174);
						end
					end
				end
				if (v80 == (1 + 0)) then
					v81 = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("Game") and workspace.Game.Map.Game:FindFirstChild("Interactions") and workspace.Game.Map.Game.Interactions:FindFirstChild("Crates");
					if v81 then
						for v152, v153 in pairs(v81:GetChildren()) do
							local v154 = (0 - 0) + (336 - (144 + 192));
							local v155;
							while true do
								if (((218 - (42 + 174)) + 0) == v154) then
									local v172 = 0;
									while true do
										if ((1 + 0) == v172) then
											v154 = 3 + 0 + 0 + 0;
											break;
										end
										if (v172 == (1504 - (363 + 1141))) then
											v155.OutlineTransparency = (1706 - (1183 + 397)) - (116 + (30 - 20));
											v155.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
											v172 = 1;
										end
									end
								end
								if ((1 + 0 + 0 + 0) == v154) then
									local v173 = 1975 - (1913 + 62);
									while true do
										if (v173 == (0 + 0)) then
											v155.FillTransparency = (1953 - 1215) - ((2475 - (565 + 1368)) + 196);
											v155.OutlineColor = Color3.fromRGB((2011 - 1476) - 280, (1827 - (1477 + 184)) - (82 - 21), 504 - (302 + 22));
											v173 = 1;
										end
										if (v173 == (857 - (564 + 292))) then
											v154 = (2 - 0) + 0;
											break;
										end
									end
								end
								if (v154 == ((5 - 3) + 1)) then
									local v174 = 0;
									while true do
										if (v174 == 0) then
											v155.Adornee = v153;
											v155.Parent = game.CoreGui;
											v174 = 305 - (244 + 60);
										end
										if (v174 == (1 + 0)) then
											v154 = 4;
											break;
										end
									end
								end
								if (v154 == ((876 - (41 + 435)) - ((1116 - (938 + 63)) + 281))) then
									table.insert(v44, v155);
									break;
								end
								if (v154 == ((1193 + 358) - ((2251 - (936 + 189)) + 140 + 285))) then
									v155 = Instance.new("Highlight");
									v155.FillColor = Color3.fromRGB(593 - (1951 - (1565 + 48)), 54 + 33 + 18, (1573 - (782 + 356)) - (522 - (176 + 91)));
									v154 = 3 - (4 - 2);
								end
							end
						end
					end
					break;
				end
			end
			break;
		end
	end
end
local function v51()
	local v82 = (0 - 0) - (1092 - (975 + 117));
	local v83;
	while true do
		if ((1123 - (118 + (2878 - (157 + 1718)))) == v82) then
			if v83 then
				local v118 = (704 + 163) - (550 + (1125 - 808));
				while true do
					if (v118 == ((1292 - 914) - (142 + (1253 - (697 + 321))))) then
						local v140 = 0 - 0;
						while true do
							if (v140 == (1 - 0)) then
								v118 = 2 + (0 - 0);
								break;
							end
							if (v140 == (0 + 0)) then
								v45.FillColor = Color3.fromRGB(477 - 222, 310 - (254 - 159), (1227 - (322 + 905)) + (611 - (602 + 9)));
								v45.OutlineColor = Color3.new((2167 - (449 + 740)) - ((1425 - (826 + 46)) + (1371 - (245 + 702))), (3 - 2) - (0 + 0), (1899 - (260 + 1638)) - (440 - (382 + 58)));
								v140 = 1;
							end
						end
					end
					if (v118 == ((25 - 17) - (5 + 0))) then
						local v141 = 0 - 0;
						while true do
							if (v141 == (2 - 1)) then
								v118 = (1494 - (902 + 303)) - (134 + (331 - 180));
								break;
							end
							if (v141 == 0) then
								v45.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
								v45.Adornee = v83;
								v141 = 1;
							end
						end
					end
					if (v118 == (1665 - (970 + 695))) then
						local v142 = 0 - 0;
						while true do
							if (v142 == (0 + 0)) then
								v45 = Instance.new("Highlight");
								v45.Name = "ExitESP";
								v142 = 1691 - (1121 + 569);
							end
							if (v142 == 1) then
								v118 = 1;
								break;
							end
						end
					end
					if (v118 == ((221 - (22 + 192)) - (686 - (483 + 200)))) then
						v45.Parent = game.CoreGui;
						break;
					end
					if (v118 == ((3455 - (1404 + 59)) - ((1592 - 1010) + (1891 - 483)))) then
						v45.FillTransparency = 0.1 + (765 - (468 + 297));
						v45.OutlineTransparency = 0 + (562 - (334 + 228));
						v118 = (20 - 14) - 3;
					end
				end
			end
			break;
		end
		if (v82 == ((6 - 3) - 2)) then
			if not v42 then
				return;
			end
			v83 = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("ExitZone") and workspace.Game.ExitZone:FindFirstChild("EscapePart");
			v82 = (2 - 0) - (0 + 0);
		end
		if (v82 == ((236 - (141 + 95)) - (0 + 0))) then
			local v103 = 0 - 0;
			while true do
				if (v103 == (0 - 0)) then
					if (v45 and v45.Adornee) then
						v45:Destroy();
					end
					v45 = nil;
					v103 = 1;
				end
				if (v103 == 1) then
					v82 = 1825 - (280 + 915 + (1723 - 1094));
					break;
				end
			end
		end
	end
end
v3:CreateToggle({Name="Player ESP",CurrentValue=false,SectionParent=v39,Callback=function(v84)
	local v85 = (0 + 0) - (0 + 0);
	while true do
		if (v85 == (241 - ((262 - 75) + 54))) then
			v40 = v84;
			if not v84 then
				local v119 = 780 - (162 + 618);
				while true do
					if (v119 == (0 + 0)) then
						v47();
						if v46 then
							local v160 = 0 + 0;
							local v161;
							while true do
								if (v160 == (163 - (92 + 71))) then
									v161 = 0 + 0;
									while true do
										if (v161 == 0) then
											v46:Disconnect();
											v46 = nil;
											break;
										end
									end
									break;
								end
							end
						end
						break;
					end
				end
			elseif not v46 then
				local v132 = 0;
				local v133;
				while true do
					if (v132 == 0) then
						v133 = (0 + 0) - (0 - 0);
						while true do
							if (v133 == (766 - (574 + 191))) then
								v49();
								break;
							end
							if (v133 == ((0 + 0) - (0 - 0))) then
								v46 = game.Players.PlayerAdded:Connect(v49);
								game.Players.PlayerRemoving:Connect(v49);
								v133 = (615 + 588) - (373 + (1678 - (254 + 595)));
							end
						end
						break;
					end
				end
			end
			break;
		end
	end
end});
v3:CreateToggle({Name="Crate ESP",CurrentValue=false,SectionParent=v39,Callback=function(v86)
	local v87 = 126 - (55 + 71);
	local v88;
	while true do
		if (v87 == (0 - 0)) then
			v88 = 0 + (1790 - (573 + 1217));
			while true do
				if (v88 == ((3129 - 1999) - (29 + 340 + (1225 - 464)))) then
					v41 = v86;
					v50();
					break;
				end
			end
			break;
		end
	end
end});
v3:CreateToggle({Name="Exit Door ESP",CurrentValue=false,SectionParent=v39,Callback=function(v89)
	v42 = v89;
	v51();
end});
task.spawn(function()
	local v90 = 939 - (714 + 225);
	local v91;
	local v92;
	while true do
		if (v90 == 1) then
			while true do
				if (v91 == ((2922 - 1922) - (451 + 549))) then
					v92 = 0 + (0 - 0);
					while true do
						local v134 = 0;
						while true do
							if (v134 == (0 + 0)) then
								if v41 then
									pcall(v50);
								end
								if (v42 and ((tick() - v92) >= (6 - 1))) then
									pcall(v51);
									v92 = tick();
								end
								v134 = 807 - (118 + 688);
							end
							if (v134 == (49 - (25 + 23))) then
								task.wait(1 + 4);
								break;
							end
						end
					end
					break;
				end
			end
			break;
		end
		if (v90 == 0) then
			v91 = 1636 - (1373 + (2149 - (927 + 959)));
			v92 = nil;
			v90 = 1;
		end
	end
end);
local v52 = v4:CreateSection("Utilities");
v4:CreateButton({Name="Inject Infinite Yield",SectionParent=v52,Callback=function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))();
end});
v4:CreateButton({Name="Inject Dex Explorer",SectionParent=v52,Callback=function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/BigBoyTimme/New.Loadstring.Scripts/refs/heads/main/Dex.Explorer", true))();
end});
