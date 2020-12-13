local ContextActionService = game:GetService("ContextActionService")
local Character = script.Parent
local RunService = game:GetService("RunService")

local current = os.time()
local BodyVelocity
local MainPart
local Config
local connection
local HoldingW = false
local HoldingS = false
local Looping = false
local FreeCam = false

local function SpeedUp(actionName, inputState, inputObject)
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
		if os.time() - current >= 0.5 then
			current = os.time()
			if Acceleration.Value < Max.Value then
				Acceleration.Value += 10
			end
		end
	until not HoldingW
end

local function SpeedDown(actionName, inputState, inputObject)
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
		if os.time() - current >= 0.5 then
			current = os.time()
			if Acceleration.Value > 0 then
				Acceleration.Value -= 15
			end
			end
	until not HoldingS
end

local function FreeCamera(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
        FreeCam = false
    else
        FreeCam = true
    end
end

local function BindActions()
	ContextActionService:BindAction("SpeedUp",SpeedUp,true,Enum.KeyCode.W)
	ContextActionService:SetTitle("SpeedUp","Accelerate")
	ContextActionService:SetPosition("SpeedUp",UDim2.new(0.5,0,-0.5,0))

	ContextActionService:BindActionAtPriority("SpeedDown",SpeedDown,true,1000,Enum.KeyCode.S)
	ContextActionService:SetTitle("SpeedDown","Break")
    ContextActionService:SetPosition("SpeedDown",UDim2.new(0.5,0,0,0))
    
    ContextActionService:BindAction("FreeCamera",FreeCamera,true,Enum.KeyCode.C)
    ContextActionService:SetTitle("FreeCamera","Free Camera")
    ContextActionService:SetPosition("FreeCamera",UDim2.new(-2,0,0,0))
end

local function UnBindActions()
	ContextActionService:UnbindAction("SpeedUp")
end

Character.Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
	local SeatPart = Character.Humanoid.SeatPart
	if SeatPart == nil then
		UnBindActions()
		Looping = false
	elseif SeatPart.Name == "SleighDriver" then
		BodyVelocity = SeatPart.Parent:WaitForChild("BodyVelocity")
		MainPart = SeatPart.Parent
		Config = MainPart.Parent.Configuration
		BindActions()
		Looping = true
	end
        connection = RunService.Heartbeat:Connect(function()
            if not FreeCam and Looping then
			    MainPart.CFrame = CFrame.new(MainPart.Position,MainPart.Position + workspace.CurrentCamera.CFrame.LookVector)
                BodyVelocity.Velocity = MainPart.CFrame.LookVector * Config.AccelerationSpeed.Value
            elseif not Looping then
                connection:Disconnect()
            end
        end)
end)
