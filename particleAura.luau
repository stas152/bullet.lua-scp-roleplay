local cr = cloneref or function(o) return o end
local pl = cr(game:GetService("Players"))
local ws = cr(game:GetService("Workspace"))
local lp = pl.LocalPlayer

local mi = 124505658459350
local ac = {}
local co = Color3.fromRGB(96, 205, 255)

local cm = nil
local na = nil

local function lf(u, f, cb)
    if not isfile(f) then
        pcall(function()
            writefile(f, game:HttpGet(u))
        end)
    end
    if isfile(f) then
        local s, r = pcall(function()
            return game:GetObjects(getcustomasset(f))[1]
        end)
        if s and r then
            cb(r)
        end
    end
end

local function lc()
    lf("https://raw.githubusercontent.com/stas152/bullet.lua-scp-roleplay/main/CosmicAura.txt.rbxmx", "CosmicAura.rbxmx", function(r) cm = r end)
end

local function lna()
    lf("https://raw.githubusercontent.com/stas152/bullet.lua-scp-roleplay/main/aura900.rbxm", "aura900.rbxm", function(r) na = r end)
end

task.spawn(lc)
task.spawn(lna)

local function gm(id)
    local ok, res = pcall(game.GetObjects, game, "rbxassetid://" .. id)
    if ok and res and res[1] then
        local m = res[1]
        m.Parent = ws
        return m
    end
end

local function gf()
    return ws:FindFirstChild("Folder")
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

local function tc(e, c)
    if e:IsA("ParticleEmitter") or e:IsA("Beam") or e:IsA("Trail") then
        e.Color = ColorSequence.new(c)
    elseif e:IsA("Light") or e:IsA("Fire") or e:IsA("Smoke") then
        e.Color = c
    elseif e:IsA("Sparkles") then
        e.SparkleColor = c
    elseif e:IsA("Highlight") then
        e.FillColor = c
        e.OutlineColor = c
    end
end

local function uc(a, c)
    tc(a, c)
    for _, e in ipairs(a:GetDescendants()) do
        tc(e, c)
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
            uc(o, co)
        end
        return
    elseif n:lower() == "newaura" then
        if not na then
            lna()
            local t = 0
            while not na and t < 5 do
                task.wait(0.5)
                t = t + 0.5
            end
        end
        if not na then return end
        
        for _, d in ipairs(na:GetDescendants()) do
            if d:IsA("Attachment") then
                local p = gp(c, "Torso")
                if d.Parent:IsA("BasePart") then
                    p = gp(c, d.Parent.Name) or p
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
                            if cl:IsA("ParticleEmitter") then
                                cl.Enabled = true
                            end
                            cl.Parent = at
                        end
                    end
                    uc(at, co)
                end
            end
        end
        return
    end

    local f = gf()
    if not f then return end
    
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
            uc(at, co)
        end
    end
end

gm(mi)

task.spawn(function()
    local f = gf()
    while not f do
        task.wait(1)
        f = gf()
    end
    if f then
        if not f:FindFirstChild("Cosmic") then
            local d = Instance.new("Folder")
            d.Name = "Cosmic"
            d.Parent = f
        end
        if not f:FindFirstChild("newaura") then
            local d = Instance.new("Folder")
            d.Name = "newaura"
            d.Parent = f
        end
    end
end)

getgenv().EffectManager = {
    Equip = eq,
    Unequip = un,
    SetColor = sc
}
