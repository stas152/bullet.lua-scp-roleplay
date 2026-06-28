local cl = cloneref or function(o) return o end
local plrs = cl(game:GetService("Players"))
local ws = cl(game:GetService("Workspace"))
local lp = plrs.LocalPlayer

local modelId = 124505658459350
local act = {}
local col = Color3.fromRGB(96, 205, 255)

local cosmicModel = nil

local function loadCosmicAsset()
    local u = "https://raw.githubusercontent.com/stas152/bullet.lua-scp-roleplay/main/CosmicAura.txt.rbxmx"
    local f = "CosmicAura.rbxmx"
    
    if not isfile(f) then
        pcall(function()
            writefile(f, game:HttpGet(u))
        end)
    end

    if isfile(f) then
        local success, res = pcall(function()
            return game:GetObjects(getcustomasset(f))[1]
        end)
        if success and res then
            cosmicModel = res
        end
    end
end

task.spawn(loadCosmicAsset)

local function getModel(id)
    local ok, res = pcall(game.GetObjects, game, "rbxassetid://" .. id)
    if ok and res and res[1] then
        local m = res[1]
        m.Parent = ws
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if m:IsA("Model") then
            m:MoveTo(hrp and (hrp.Position + Vector3.new(0, 0, -5)) or Vector3.new(0, 5, 0))
        elseif m:IsA("BasePart") then
            m.Position = Vector3.new(0, 5, 0)
        end
        return m
    end
end

local function getFolder()
    return ws:FindFirstChild("Folder")
end

local function getRig(char)
    return char:FindFirstChild("UpperTorso") and "R15" or "R6"
end

local map = {
    ["Torso"] = {R6 = "Torso", R15 = "UpperTorso"},
    ["Head"] = {R6 = "Head", R15 = "Head"},
    ["Left Arm"] = {R6 = "Left Arm", R15 = "LeftUpperArm"},
    ["Right Arm"] = {R6 = "Right Arm", R15 = "RightUpperArm"},
    ["Left Leg"] = {R6 = "Left Leg", R15 = "LeftUpperLeg"},
    ["Right Leg"] = {R6 = "Right Leg", R15 = "RightUpperLeg"},
}

local function getPart(char, name)
    if not char then return end
    local rig = getRig(char)
    if map[name] then
        return char:FindFirstChild(map[name][rig])
    end
    return char:FindFirstChild(name)
end

local function updateColor(att, color)
    for _, eff in ipairs(att:GetChildren()) do
        if eff:IsA("ParticleEmitter") or eff:IsA("Beam") or eff:IsA("Trail") then
            eff.Color = ColorSequence.new(color)
        elseif eff:IsA("Light") then
            eff.Color = color
        end
    end
end

local function unequip(name)
    if act[name] then
        for _, obj in ipairs(act[name]) do
            pcall(function()
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end)
        end
        act[name] = nil
    end
end

local function equip(name)
    local char = lp.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    unequip(name)
    act[name] = {}
    
    -- Обработка Cosmic VFX
    if name:lower() == "cosmic" then
        if not cosmicModel then
            loadCosmicAsset()
            local timeout = 0
            while not cosmicModel and timeout < 5 do
                task.wait(0.5)
                timeout = timeout + 0.5
            end
        end
        
        if not cosmicModel then return end
        
        local function setup(obj)
            local cloned = obj:Clone()
            if cloned:IsA("Attachment") then
                cloned.Parent = hrp
                for _, e in ipairs(cloned:GetDescendants()) do
                    if e:IsA("ParticleEmitter") then e.Enabled = true end
                end
                table.insert(act[name], cloned)
            elseif cloned:IsA("ParticleEmitter") or cloned:IsA("Beam") or cloned:IsA("Trail") or cloned:IsA("Light") then
                cloned.Parent = hrp
                if cloned:IsA("ParticleEmitter") then cloned.Enabled = true end
                table.insert(act[name], cloned)
            elseif cloned:IsA("BasePart") then
                cloned.Parent = char
                cloned.CanCollide = false
                cloned.Anchored = false
                cloned.CFrame = hrp.CFrame
                local w = Instance.new("WeldConstraint")
                w.Part0 = hrp
                w.Part1 = cloned
                w.Parent = hrp
                for _, e in ipairs(cloned:GetDescendants()) do
                    if e:IsA("ParticleEmitter") then e.Enabled = true end
                end
                table.insert(act[name], cloned)
                table.insert(act[name], w)
            end
        end
        
        if cosmicModel:IsA("Model") or cosmicModel:IsA("Folder") then
            for _, child in ipairs(cosmicModel:GetChildren()) do
                setup(child)
            end
        else
            setup(cosmicModel)
        end

        for _, obj in ipairs(act[name]) do
            if obj:IsA("Attachment") or obj:IsA("BasePart") then
                updateColor(obj, col)
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                obj.Color = ColorSequence.new(col)
            elseif obj:IsA("Light") then
                obj.Color = col
            end
        end
        return
    end

    local f = getFolder()
    if not f then return end
    
    local item = f:FindFirstChild(name, true)
    if not item then return end
    
    local targetName = "Torso"
    if name:lower():find("halo") or name:lower():find("head") then
        targetName = "Head"
    end
    
    for _, desc in ipairs(item:GetDescendants()) do
        if desc:IsA("Attachment") then
            local part = getPart(char, targetName)
            if not part and desc.Parent:IsA("BasePart") then
                part = getPart(char, desc.Parent.Name)
            end
            part = part or hrp
            
            if part then
                local attName = desc.Name .. "_" .. name .. "_Custom"
                local att = part:FindFirstChild(attName) or Instance.new("Attachment")
                att.Name = attName
                att.CFrame = desc.CFrame
                att.Parent = part
                
                table.insert(act[name], att)
                
                for _, eff in ipairs(desc:GetChildren()) do
                    if eff:IsA("ParticleEmitter") or eff:IsA("Beam") or eff:IsA("Trail") or eff:IsA("Light") or eff:IsA("Fire") or eff:IsA("Smoke") or eff:IsA("Sparkles") then
                        local clone = eff:Clone()
                        clone.Parent = att
                    end
                end
                updateColor(att, col)
            end
        end
    end
end

local function setGlobalColor(newCol)
    col = newCol
    for _, atts in pairs(act) do
        for _, att in ipairs(atts) do
            if att:IsA("Attachment") or att:IsA("BasePart") then
                updateColor(att, col)
            elseif att:IsA("ParticleEmitter") or att:IsA("Beam") or att:IsA("Trail") then
                att.Color = ColorSequence.new(col)
            elseif att:IsA("Light") then
                att.Color = col
            end
        end
    end
end

getModel(modelId)

getgenv().EffectManager = {
    Equip = equip,
    Unequip = unequip,
    SetColor = setGlobalColor
}
