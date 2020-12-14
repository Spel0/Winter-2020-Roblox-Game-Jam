local ContextActionService = game:GetService("ContextActionService")
local Character = script.Parent --Since Script is in StarterCharacterScripts, our Character is already loaded and script is already placed inside of it.
local RunService = game:GetService("RunService")

local current = time() --Debounce
local BodyVelocity --Various Variables(lol)
local MainPart
local Config
local connection
local HoldingW = false --Bool Variables
local HoldingS = false
local Looping = false
local FreeCam = false

local function SpeedUp(actionName, inputState, inputObject) --Add Speed when pressing W/Holding Accelerate Button
	if inputState == Enum.UserInputState.Cancel or inputState == Enum.UserInputState.End then
		HoldingW = false
	else
		HoldingW = true
	end
    repeat
        local Acceleration = Config.AccelerationSpeed
		local Max = Config.MaxSpeed
		RunService.Heartbeat:Wait()
		if Acceleration.Value > Max.Value then
			Acceleration.Value = 100
		end
		if time() - current >= 0.5 then
			current = time()
			if Acceleration.Value < Max.Value then
				Acceleration.Value += 10
			end
		end
	until not HoldingW
end

local function SpeedDown(actionName, inputState, inputObject) --Decrease Speed when pressing S/holding Break button
	if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
		HoldingS = false
	else
		HoldingS = true
	end
    repeat
        local Acceleration = Config.AccelerationSpeed
		RunService.Heartbeat:Wait()
		if Acceleration.Value < 0 then
			Acceleration.Value = 0
		end
		if time() - current >= 0.5 then
			current = time()
			if Acceleration.Value > 0 then
				Acceleration.Value -= 15
			end
			end
	until not HoldingS
end

local function FreeCamera(actionName, inputState, inputObject) --Free Camera (Simple code, yet very buggy)
    if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
        FreeCam = false
    else
        FreeCam = true
    end
end

local function BindActions() --CAS actions binding
	ContextActionService:BindAction("SpeedUp",SpeedUp,true,Enum.KeyCode.W)
	ContextActionService:SetTitle("SpeedUp","Accelerate")
	ContextActionService:SetPosition("SpeedUp",UDim2.new(0.5,0,-0.5,0))

	ContextActionService:BindAction("SpeedDown",SpeedDown,true,Enum.KeyCode.S)
	ContextActionService:SetTitle("SpeedDown","Break")
    ContextActionService:SetPosition("SpeedDown",UDim2.new(0.5,0,0,0))
    
    ContextActionService:BindAction("FreeCamera",FreeCamera,true,Enum.KeyCode.C)
    ContextActionService:SetTitle("FreeCamera","Free Camera")
    ContextActionService:SetPosition("FreeCamera",UDim2.new(-2,0,0,0))
end

local function UnBindActions() --CAS Actions unbinding
	ContextActionService:UnbindAction("SpeedUp")
	ContextActionService:UnbindAction("SpeedDown")
	ContextActionService:UnbindAction("FreeCamera")
end

Character.Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function() --Main Part of the Script
	local SeatPart = Character.Humanoid.SeatPart
	if SeatPart == nil then --If Player Leaves Vehicle
		UnBindActions()
		Looping = false
	elseif SeatPart.Name == "SleighDriver" then --If Player Enters Vehicle
		BodyVelocity = SeatPart.Parent:WaitForChild("BodyVelocity")
		MainPart = SeatPart.Parent
		Config = MainPart.Parent.Configuration
		BindActions()
		Looping = true
	end
        connection = RunService.Heartbeat:Connect(function() --Sleigh Flying System
            if not FreeCam and Looping then
			    MainPart.CFrame = CFrame.new(MainPart.Position,MainPart.Position + workspace.CurrentCamera.CFrame.LookVector)
                BodyVelocity.Velocity = MainPart.CFrame.LookVector * Config.AccelerationSpeed.Value
            elseif not Looping then
                connection:Disconnect()
            end
        end)
end)
