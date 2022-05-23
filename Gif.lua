--****************************************************
-- File: Gif.lua
--
-- Purpose: Gif class; creating gifs on Roblox.
--
-- Written By: Ivan
--
-- Compiler: Visual Studio Code
--
-- API Reference
-- -------------
-- Gif.new()
-- Gif:Play()
-- Gif:Stop()
-- Gif:Destroy()
-- 
-- Properties
-- ----------
-- Name: 		Gif.instance
-- Description: image label, image button, decal, 
-- 				or texture
--
-- Name: 		Gif.id
-- Description: list of image IDs to cycle through
--
-- Name: 		Gif.enabled
-- Description: debounce
--
-- Name: 		Gif.rows
-- Description: number of rows in the spritesheet
--
-- Name:		Gif.columns
-- Description: number of columns in the spritesheet
--
-- Name:		Gif.frames
-- Description: number of frames or images to cycle
--				through
--
-- Name:		Gif.start
-- Description: first frame to start at
--
-- Name:		Gif.direction
-- Description: direction of the spritesheet
--				animation; "horizontal" or "vertical"
--
-- Name:		Gif.rate
-- Description: speed of the animation; wait time
--				between each frame
--
-- Name:		Gif.width
-- Description: width of the spritesheet
--
-- Name:		Gif.height
-- Description: height of the spritesheet
--
-- Name:		Gif.maxLoops
-- Description: number of loops to play
--****************************************************
local Gif = {}
local mt = {__index = Gif}

--****************************************************
-- Function: Gif.new
--
-- Purpose: Constructor.
--****************************************************
function Gif.new(instance, id)
	if not instance:IsA("ImageLabel") and not instance:IsA("ImageButton") and not instance:IsA("Decal") then
		error("bad argument (ImageLabel, ImageButton, or Decal expected, got "..instance.ClassName..")")
	end
	if instance:IsA("Texture") and not instance.Parent:IsA("BasePart") then
		error("expected BasePart as Parent of Texture")
	end
	local self = setmetatable({}, mt)
	self.instance = instance
	self.id = (type(id) == "string") and {id} or id
	self.enabled = false
	self.rows = 1
	self.columns = 1
	self.frames = (self.instance.ClassName == "Decal") and #self.id or self.rows * self.columns
	self.start = 1
	self.direction = "horizontal"
	self.rate = 1/30
	self.width = 0
	self.height = 0
	self.maxLoops = 0
	self.default = {
		spritesheet = "rbxassetid://8072940546",
		icon = "rbxasset://textures/ui/ErrorIcon.png"
	}
	self.face = { -- for textures
		width = {
			Back = "X",
			Bottom = "X",
			Front = "X",
			Left = "Z",
			Right = "Z",
			Top = "X"
		},
		height = {
			Back = "Y",
			Bottom = "Z",
			Front = "Y",
			Left = "Y",
			Right = "Y",
			Top = "Z"
		}
	}
	return self
end

--****************************************************
-- Function: Gif:update
--
-- Purpose: Updates the member variables.
--****************************************************
function Gif:update()
	self.id = (type(self.id) == "string") and {self.id} or (type(self.id) ~= "table" or #self.id == 0) and {(self.instance.ClassName == "Decal") and self.default.icon or self.default.spritesheet} or self.id
	self.rows = (self.id[1] == self.default.spritesheet) and 2 or (self.rows == 0) and 1 or math.abs(self.rows)
	self.columns = (self.id[1] == self.default.spritesheet) and 2 or (self.columns == 0) and 1 or math.abs(self.columns)
	self.frames = (self.instance.ClassName == "Decal") and #self.id or (self.frames <= 1) and (self.rows * self.columns) or math.clamp(math.abs(self.frames), 1, self.rows * self.columns)
	self.start = math.clamp(math.abs(self.start), 1, self.frames)
	self.direction = string.lower(self.direction)
	self.rate = math.abs(self.rate)
	self.width = (self.instance:IsA("Texture")) and self.instance.Parent.Size[self.face.width[self.instance.Face.Name]] or (self.id[1] == self.default.spritesheet) and 1024 or math.abs(self.width)
	self.height = (self.instance:IsA("Texture")) and self.instance.Parent.Size[self.face.height[self.instance.Face.Name]] or (self.id[1] == self.default.spritesheet) and 1024 or math.abs(self.height)
	self.maxLoops = math.abs(self.maxLoops)
	if self.direction ~= "horizontal" and self.direction ~= "vertical" then
		self.direction = "horizontal"
	end
	if string.find(self.instance.ClassName, "Image") then
		self.instance.ImageRectSize = Vector2.new(self.width/self.columns, self.height/self.rows)
	elseif self.instance:IsA("Texture") then
		self.instance.StudsPerTileU = self.width * self.columns
		self.instance.StudsPerTileV = self.height * self.rows
	end
end

--****************************************************
-- Function: Gif:setFrames
--
-- Purpose: Calculates the position of each frame.
--****************************************************
function Gif:setFrames()
	self.framePositions = {}
	if self.direction == "horizontal" then
		for y = 0, self.rows - 1 do
			for x = 0, self.columns - 1 do
				self:addFrame(x, y)
			end
		end
	elseif self.direction == "vertical" then
		for x = 0, self.columns - 1 do
			for y = 0, self.rows - 1 do
				self:addFrame(x, y)
			end
		end
	end
end

--****************************************************
-- Function: Gif:addFrame
--
-- Purpose: Stores the position of a frame.
--****************************************************
function Gif:addFrame(x, y)
	if #self.framePositions < self.frames then
		table.insert(self.framePositions, (self.instance:IsA("Texture")) and Vector2.new(self.width * x, self.height * y) or Vector2.new(x, y))
	end
end

--****************************************************
-- Function: Gif:Play
--
-- Purpose: Plays the gif.
--****************************************************
function Gif:Play()
	self:update()
	self.instance[string.find(self.instance.ClassName, "Image") and "Image" or "Texture"] = self.id[1]
	if self.frames > 1 then
		task.spawn(function()
			if self.instance.ClassName ~= "Decal" then
				self:setFrames()
			end
			self.enabled = true
			local counter = 0
			while self.enabled do
				for i = self.start, self.frames do
					if self.enabled then
						if #self.id > 1 then
							self.instance[string.find(self.instance.ClassName, "Image") and "Image" or "Texture"] = self.id[i]
						elseif self.instance.ClassName ~= "Decal" then
							if string.find(self.instance.ClassName, "Image") then
								self.instance.ImageRectOffset = self.framePositions[i] * self.instance.ImageRectSize
							elseif self.instance:IsA("Texture") then
								self.instance.OffsetStudsU = self.framePositions[i].X
								self.instance.OffsetStudsV = self.framePositions[i].Y
							end
						end
					else
						break
					end
					task.wait(self.rate)
				end
				counter += 1
				if self.maxLoops ~= 0 and counter == self.maxLoops then
					break
				end
				self.start = 1
			end
		end)
	end
end

--****************************************************
-- Function: Gif:Stop
--
-- Purpose: Stops the gif.
--****************************************************
function Gif:Stop()
	self.enabled = false
end

--****************************************************
-- Function: Gif:Destroy
--
-- Purpose: Destructor.
--****************************************************
function Gif:Destroy()
	self:Stop()
	if self.framePositions then
		table.clear(self.framePositions)
	end
	if self.instance then
		self.instance = nil
	end
	self = nil
end

return Gif
