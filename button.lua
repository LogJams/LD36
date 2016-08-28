Button = {}


function Button.new(x, y, w, h, text)
  nu = setmetatable({}, { __index = Button })
  nu.x = x
  nu.y = y
  nu.w = w
  nu.h = h
  nu.text = text
  nu.font = love.graphics.newFont()
  nu.fontColor = {0, 0, 0}
  nu.color = {128, 128, 128}
  nu.hover = false
  nu.clicked = false
  return nu 
end

function Button:update(mousex, mousey, click)
  self.hover = mousex > self.x and mousex < self.x + self.w  and
               mousey > self.y and mousey < self.y + self.h
  self.clicked = hover and click
end



function Button:draw()
  love.graphics.setFont(self.font)
  -- draw a block
  if self.hover then
    love.graphics.setColor(self.color[1]*0.75, self.color[2]*0.75, self.color[3]*0.75)
  else
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
  end
  local fontW = self.font:getWidth(self.text)
  local fontH = self.font:getHeight(self.text)
  love.graphics.rectangle("fill", self.x + (self.w - fontW)/2, self.y - (self.h - fontH)/2, self.w, self.h)
  love.graphics.setColor(self.fontColor[1], self.fontColor[2], self.fontColor[3])
  love.graphics.print(self.text, self.x, self.y) 
end

