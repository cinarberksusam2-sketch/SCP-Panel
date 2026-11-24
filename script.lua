local P,W,R=game:GetService("Players"),game:GetService("Workspace"),game:GetService("RunService")
local LP=P.LocalPlayer
local pE,iE,nc,sp,tS,md=false,false,false,false,36,"P"
local it={"card","keycard","level","omni","o5","mp5","p90","ak","m4","glock","gun","rifle","pistol","shotgun","medkit","bandage","crowbar","bat","knife","bıçak","çubuk","kart"}
local ig={"lamp","bed","torch","door","box","vending","wall","floor","decor","light","radio","display","shop","vitrin"}

local function isPlr(o)
    while o and o~=W do
        if P:GetPlayerFromCharacter(o) or o:FindFirstChildOfClass("Humanoid") then return true end
        o=o.Parent
    end
    return false
end

local function val(n)
    n=string.lower(tostring(n))
    for _,v in ipairs(ig) do if string.find(n,v,1,true) then return false end end
    for _,v in ipairs(it) do if string.find(n,v,1,true) then return true end end
    return false
end

local function gp(o)
    return o:IsA("BasePart") and o or o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart",true)
end

local function col(o)
    local pt=gp(o)
    if not pt or pt.Position.Y<-100 or pt.Position.Y>600 then return false end
    if o:IsA("Tool") or o:FindFirstChildWhichIsA("ProximityPrompt",true) or o:FindFirstChildWhichIsA("ClickDetector",true) then return true end
    local pr=o.Parent
    return (pr and pr~=W and (pr:FindFirstChildWhichIsA("ProximityPrompt",true) or pr:FindFirstChildWhichIsA("ClickDetector",true))) and true or false
end

local function clr(t)
    for _,v in ipairs(W:GetDescendants()) do if v.Name==t then v:Destroy() end end
end

local function esp(o,tx,c,t)
    if not o or o:FindFirstChild(t) then return end
    local pt=gp(o)
    if not pt then return end
    local h=Instance.new("Highlight",o)
    h.Name,h.Adornee,h.FillColor,h.OutlineColor,h.FillTransparency,h.DepthMode=t,o,c,Color3.new(1,1,1),0.5,Enum.HighlightDepthMode.AlwaysOnTop
    if tx then
        local b=Instance.new("BillboardGui",h)
        b.Adornee,b.Size,b.StudsOffset,b.AlwaysOnTop=pt,UDim2.new(0,120,0,22),Vector3.new(0,1.2,0),true
        local l=Instance.new("TextLabel",b)
        l.Size,l.BackgroundTransparency,l.TextColor3,l.TextStrokeTransparency,l.TextSize,l.Text=UDim2.new(1,0,1,0),1,c,0,12,tx
    end
end

local function getIt()
    local ls,sn={},{}
    for _,v in ipairs(W:GetDescendants()) do
        if (v:IsA("Tool") or v:IsA("Model") or v:IsA("BasePart")) and val(v.Name) and not isPlr(v) then
            local t=(v.Parent and (v.Parent:IsA("Tool") or v.Parent:IsA("Model")) and val(v.Parent.Name)) and v.Parent or v
            if not sn[t] and col(t) then sn[t]=true table.insert(ls,t) end
        end
    end
    return ls
end

local function tp(cf)
    local ch=LP.Character
    local hr=ch and ch:FindFirstChild("HumanoidRootPart")
    if not hr then return end
    pcall(function() hr.Velocity=Vector3.new(0,0,0) end)
    local rp=RaycastParams.new()
    rp.FilterDescendantsInstances,rp.FilterType={ch},Enum.RaycastFilterType.Exclude
    local rs=W:Raycast(cf.Position+Vector3.new(0,3,0),Vector3.new(0,-15,0),rp)
    hr.CFrame=CFrame.new((rs and rs.Position or cf.Position)+Vector3.new(0,3,0))
end

R.Heartbeat:Connect(function(dt)
    local ch=LP.Character
    if not ch then return end
    if nc then for _,v in ipairs(ch:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end
    if sp then
        local hm,hr=ch:FindFirstChildOfClass("Humanoid"),ch:FindFirstChild("HumanoidRootPart")
        if hm then hm.WalkSpeed=tS end
        if hm and hr and hm.MoveDirection.Magnitude>0 then hr.CFrame=hr.CFrame+(hm.MoveDirection*math.max(0,tS-16)*dt) end
    end
end)

local gui=Instance.new("ScreenGui")
gui.Name,gui.ResetOnSpawn="SCP_Mini",false
pcall(function() gui.Parent=(gethui and gethui()) or game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end
for _,c in ipairs(gui.Parent:GetChildren()) do if c.Name=="SCP_Mini" and c~=gui then c:Destroy() end end

local tog=Instance.new("TextButton",gui)
tog.Size,tog.Position,tog.BackgroundColor3,tog.TextColor3,tog.Text=UDim2.new(0,80,0,28),UDim2.new(0,15,0,60),Color3.fromRGB(30,30,35),Color3.new(1,1,1),"Menü"

local frm=Instance.new("Frame",gui)
frm.Size,frm.Position,frm.BackgroundColor3,frm.Active,frm.Draggable=UDim2.new(0,195,0,315),UDim2.new(0,15,0,92),Color3.fromRGB(22,22,28),true,true
tog.MouseButton1Click:Connect(function() frm.Visible=not frm.Visible end)

local function btn(tx,y,cb)
    local b=Instance.new("TextButton",frm)
    b.Size,b.Position,b.BackgroundColor3,b.TextColor3,b.TextSize,b.Text=UDim2.new(0.9,0,0,26),UDim2.new(0.05,0,0,y),Color3.fromRGB(160,40,40),Color3.new(1,1,1),13,tx..": KAPALI"
    local s=false
    b.MouseButton1Click:Connect(function()
        s=not s b.Text=tx..(s and ": AÇIK" or ": KAPALI")
        b.BackgroundColor3=s and Color3.fromRGB(40,150,70) or Color3.fromRGB(160,40,40) cb(s)
    end)
end

btn("Oyuncu ESP",8,function(s) pE=s clr("P_ESP") if s then for _,p in ipairs(P:GetPlayers()) do if p~=LP and p.Character then esp(p.Character,nil,Color3.new(1,0.2,0.2),"P_ESP") end end end end)
btn("Eşya ESP",38,function(s) iE=s clr("I_ESP") if s then for _,i in ipairs(getIt()) do esp(i,i.Name,Color3.new(0.2,1,0.4),"I_ESP") end end end)
btn("Noclip",68,function(s) nc=s end)

local sB=Instance.new("TextButton",frm)
sB.Size,sB.Position,sB.BackgroundColor3,sB.TextColor3,sB.TextSize,sB.Text=UDim2.new(0.54,0,0,26),UDim2.new(0.05,0,0,98),Color3.fromRGB(160,40,40),Color3.new(1,1,1),12,"Hız ("..tS.."): KAPALI"
local sM=Instance.new("TextButton",frm)
sM.Size,sM.Position,sM.BackgroundColor3,sM.TextColor3,sM.TextSize,sM.Text=UDim2.new(0.16,0,0,26),UDim2.new(0.61,0,0,98),Color3.fromRGB(50,50,65),Color3.new(1,1,1),15,"-"
local sP=Instance.new("TextButton",frm)
sP.Size,sP.Position,sP.BackgroundColor3,sP.TextColor3,sP.TextSize,sP.Text=UDim2.new(0.16,0,0,26),UDim2.new(0.79,0,0,98),Color3.fromRGB(50,50,65),Color3.new(1,1,1),15,"+"

local function uS()
    sB.Text="Hız ("..tS..")"..(sp and ": AÇIK" or ": KAPALI")
    sB.BackgroundColor3=sp and Color3.fromRGB(40,150,70) or Color3.fromRGB(160,40,40)
end
sB.MouseButton1Click:Connect(function() sp=not sp uS() if not sp and LP.Character then local h=LP.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=16 end end end)
sM.MouseButton1Click:Connect(function() tS=math.max(16,tS-4) uS() end)
sP.MouseButton1Click:Connect(function() tS=math.min(120,tS+4) uS() end)

local tP=Instance.new("TextButton",frm)
tP.Size,tP.Position,tP.Text,tP.TextSize,tP.BackgroundColor3,tP.TextColor3=UDim2.new(0.43,0,0,24),UDim2.new(0.05,0,0,130),"Oyuncu TP",12,Color3.fromRGB(50,90,160),Color3.new(1,1,1)
local tI=Instance.new("TextButton",frm)
tI.Size,tI.Position,tI.Text,tI.TextSize,tI.BackgroundColor3,tI.TextColor3=UDim2.new(0.43,0,0,24),UDim2.new(0.52,0,0,130),"Eşya TP",12,Color3.fromRGB(40,45,55),Color3.new(1,1,1)

local sc=Instance.new("ScrollingFrame",frm)
sc.Size,sc.Position,sc.BackgroundColor3,sc.ScrollBarThickness=UDim2.new(0.9,0,0,148),UDim2.new(0.05,0,0,158),Color3.fromRGB(32,32,40),4
Instance.new("UIListLayout",sc).Padding=UDim.new(0,3)

local function lTP(m)
    md=m tP.BackgroundColor3=(m=="P") and Color3.fromRGB(50,90,160) or Color3.fromRGB(40,45,55) tI.BackgroundColor3=(m=="I") and Color3.fromRGB(50,90,160) or Color3.fromRGB(40,45,55)
    for _,v in ipairs(sc:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
    local c=0
    if m=="P" then
        for _,p in ipairs(P:GetPlayers()) do
            if p~=LP then
                c=c+1 local b=Instance.new("TextButton",sc)
                b.Size,b.Text,b.TextSize,b.BackgroundColor3,b.TextColor3=UDim2.new(1,-6,0,24),p.Name,12,Color3.fromRGB(50,50,60),Color3.new(1,1,1)
                b.MouseButton1Click:Connect(function() if p.Character then tp(p.Character:GetPivot()*CFrame.new(0,0,3)) end end)
            end
        end
    else
        for _,i in ipairs(getIt()) do
            c=c+1 local b=Instance.new("TextButton",sc)
            b.Size,b.Text,b.TextSize,b.BackgroundColor3,b.TextColor3=UDim2.new(1,-6,0,24),i.Name,12,Color3.fromRGB(40,65,50),Color3.new(0.5,1,0.6)
            b.MouseButton1Click:Connect(function() local pt=gp(i) if pt and pt.Parent and col(i) then tp(pt.CFrame) end task.wait(0.2) lTP("I") end)
        end
        if c==0 then local l=Instance.new("TextLabel",sc) l.Size,l.BackgroundTransparency,l.TextColor3,l.TextSize,l.Text=UDim2.new(1,0,0,26),1,Color3.fromRGB(170,170,170),12,"Şu an yerde eşya yok" end
    end
    sc.CanvasSize=UDim2.new(0,0,0,c*27)
end

tP.MouseButton1Click:Connect(function() lTP("P") end)
tI.MouseButton1Click:Connect(function() lTP("I") end)
lTP("P")

task.spawn(function()
    while gui and gui.Parent do
        task.wait(3)
        if iE then for _,i in ipairs(getIt()) do esp(i,i.Name,Color3.new(0.2,1,0.4),"I_ESP") end end
        if frm.Visible and md=="I" then lTP("I") end
    end
end)
