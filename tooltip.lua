Tooltip = {}

font = love.graphics.newFont()
lastX = 0
lastY = 0

function Tooltip.setup()
  Tooltip.visible = true
  Tooltip.text = "this is the\ntooltip text!"
  Tooltip.border = 3 --border around text in px
  Tooltip.timeLimit = 0.5
  Tooltip.timer = Tooltip.timeLimit
  
end

function Tooltip.update(dt)
  --decide if the tooltip should be shown
  Tooltip.timer = Tooltip.timer - dt
  if math.abs(lastX - love.mouse.getX()) > 4 or math.abs(lastY - love.mouse.getY()) > 4 then
    Tooltip.timer = Tooltip.timeLimit
  end
  lastX = love.mouse.getX()
  lastY = love.mouse.getY()
  Tooltip.visible = (Tooltip.timer <= 0)
  -- calculate the size of the tooltip box
  maxLength = 75
  nLines = 0
  for line in magicline(Tooltip.text) do
    maxLength = math.max(maxLength, font:getWidth(line) + 2*Tooltip.border) 
    nLines = nLines + 1
  end
  Tooltip.height = 14*nLines + 2*Tooltip.border
  Tooltip.width = maxLength
end

function Tooltip.draw()
  if Tooltip.visible then
    love.graphics.setColor(255, 31, 31)
    love.graphics.rectangle("fill", love.mouse.getX(),
                            love.mouse.getY() - Tooltip.height,
                            maxLength, Tooltip.height)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(Tooltip.text, love.mouse.getX() + Tooltip.border,
                        love.mouse.getY()-Tooltip.height + Tooltip.border);
  end
end

function magicline(s)
        if s:sub(-1)~="\n" then s=s.."\n" end
        return s:gmatch("(.-)\n")
end