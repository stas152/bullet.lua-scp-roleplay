local cr = cloneref or function(o) return o end
local pl = cr(game:GetService("Players"))
local ws = cr(game:GetService("Workspace"))
local lp = pl.LocalPlayer

local mi = 124505658459350
local ac = {}
local co = Color3.fromRGB(96, 205, 255)
local cm = nil

local function gf()
    local f = ws:FindFirstChild("niggasploit")
    if not f then
        f = Instance.new("Folder")
        f.Name = "niggasploit"
        f.Parent = ws
    end
    return f
end

local function oa(a)
    if a:IsA("Attachment") then
        a.Position = Vector3.new(0, 99999, 0)
    end
end

local f = gf()
f.DescendantAdded:Connect(oa)

local function lc()
    local u = "https://raw.githubusercontent.com/stas152/bullet.lua-scp-roleplay/main/CosmicAura.txt.rbxmx"
    local f_name = "CosmicAura.rbxmx"
    if not isfile(f_name) then
        pcall(function()
            writefile(f_name, game:HttpGet(u))
        end)
    end
    if isfile(f_name) then
        local s, r = pcall(function()
            return game:GetObjects(getcustomasset(f_name))[1]
        end)
        if s and r then
            local d = f:FindFirstChild("Cosmic")
            if d then d:Destroy() end
            cm = r
            cm.Name = "Cosmic"
            cm.Parent = f
        end
    end
end

task.spawn(lc)

local function gm(id)
    local o, r = pcall(game.GetObjects, game, "rbxassetid://" .. id)
    if o and r and r[1] then
        local m = r[1]
        if m:IsA("Folder") or m:IsA("Model") then
            for _, c in ipairs(m:GetChildren()) do
                c.Parent = f
            end
            m:Destroy()
        else
            m.Parent = f
        end
    end
end

local function gr(c)
    return c:FindFirstChild("UpperTorso") and "R15" or "R6"
end

local mp = {
    ["Torso"] = {R6 = "Torso", R15 = "UpperTorso"},
    ["Head"] = {R6 = "Head", R15 = "Head"},
    ["Left Arm"] = {R6 = "Left Arm", R15 = "LeftUpperArm"},
    ["Right Arm"] = {R6 = "Right Arm", R15 = "RightUpperArm"},
    ["Left Leg"] = {R6 = "Left Leg", R15 = "LeftUpperLeg"},
    ["Right Leg"] = {R6 = "Right Leg", R15 = "RightUpperLeg"},
}

local function gp(c, n)
    if not c then return end
    local r = gr(c)
    if mp[n] then
        return c:FindFirstChild(mp[n][r])
    end
    return c:FindFirstChild(n)
end

local function uc(a, c)
    for _, e in ipairs(a:GetChildren()) do
        if e:IsA("ParticleEmitter") or e:IsA("Beam") or e:IsA("Trail") then
            e.Color = ColorSequence.new(c)
        elseif e:IsA("Light") then
            e.Color = c
        end
    end
end

local function un(n)
    if ac[n] then
        for _, o in ipairs(ac[n]) do
            pcall(function()
                if o and o.Parent then
                    o:Destroy()
                end
            end)
        end
        ac[n] = nil
    end
end

local function eq(n)
    local c = lp.Character
    if not c then return end
    local h = c:FindFirstChild("HumanoidRootPart")
    if not h then return end
    un(n)
    ac[n] = {}
    if n:lower() == "cosmic" then
        if not cm then
            lc()
            local t = 0
            while not cm and t < 5 do
                task.wait(0.5)
                t = t + 0.5
            end
        end
        if not cm then return end
        local function s(o)
            local cl = o:Clone()
            if cl:IsA("Attachment") then
                cl.Parent = h
                for _, e in ipairs(cl:GetDescendants()) do
                    if e:IsA("ParticleEmitter") then e.Enabled = true end
                end
                table.insert(ac[n], cl)
            elseif cl:IsA("ParticleEmitter") or cl:IsA("Beam") or cl:IsA("Trail") or cl:IsA("Light") then
                cl.Parent = h
                if cl:IsA("ParticleEmitter") then cl.Enabled = true end
                table.insert(ac[n], cl)
            elseif cl:IsA("BasePart") then
                cl.Parent = c
                cl.CanCollide = false
                cl.Anchored = false
                cl.CFrame = h.CFrame
                local w = Instance.new("WeldConstraint")
                w.Part0 = h
                w.Part1 = cl
                w.Parent = h
                for _, e in ipairs(cl:GetDescendants()) do
                    if e:IsA("ParticleEmitter") then e.Enabled = true end
                end
                table.insert(ac[n], cl)
                table.insert(ac[n], w)
            end
        end
        if cm:IsA("Model") or cm:IsA("Folder") then
            for _, ch in ipairs(cm:GetChildren()) do
                s(ch)
            end
        else
            s(cm)
        end
        for _, o in ipairs(ac[n]) do
            if o:IsA("Attachment") or o:IsA("BasePart") then
                uc(o, co)
            elseif o:IsA("ParticleEmitter") or o:IsA("Beam") or o:IsA("Trail") then
                o.Color = ColorSequence.new(co)
            elseif o:IsA("Light") then
                o.Color = co
            end
        end
        return
    end
    local i = f:FindFirstChild(n, true)
    if not i then return end
    local tn = "Torso"
    if n:lower():find("halo") or n:lower():find("head") then
        tn = "Head"
    end
    for _, d in ipairs(i:GetDescendants()) do
        if d:IsA("Attachment") then
            local p = gp(c, tn)
            if not p and d.Parent:IsA("BasePart") then
                p = gp(c, d.Parent.Name)
            end
            p = p or h
            if p then
                local an = d.Name .. "_" .. n .. "_Custom"
                local at = p:FindFirstChild(an) or Instance.new("Attachment")
                at.Name = an
                at.CFrame = d.CFrame
                at.Parent = p
                table.insert(ac[n], at)
                for _, ef in ipairs(d:GetChildren()) do
                    if ef:IsA("ParticleEmitter") or ef:IsA("Beam") or ef:IsA("Trail") or ef:IsA("Light") or ef:IsA("Fire") or ef:IsA("Smoke") or ef:IsA("Sparkles") then
                        local cl = ef:Clone()
                        cl.Parent = at
                    end
                end
                uc(at, co)
            end
        end
    end
end

local function sc(nc)
    co = nc
    for _, as in pairs(ac) do
        for _, at in ipairs(as) do
            if at:IsA("Attachment") or at:IsA("BasePart") then
                uc(at, co)
            elseif at:IsA("ParticleEmitter") or at:IsA("Beam") or at:IsA("Trail") then
                at.Color = ColorSequence.new(co)
            elseif at:IsA("Light") then
                at.Color = co
            end
        end
    end
end

for _, d in ipairs(f:GetDescendants()) do
    oa(d)
end

gm(mi)

task.spawn(function()
    while not f do
        task.wait(1)
    end
    if not f:FindFirstChild("Cosmic") then
        local d = Instance.new("Folder")
        d.Name = "Cosmic"
        d.Parent = f
    end
end)

getgenv().EffectManager = {
    Equip = eq,
    Unequip = un,
    SetColor = sc
}
