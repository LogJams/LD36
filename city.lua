require "names"

City = {}

CityTypeStrings = {"Hamlet", "Village",
                    "Town", "Large Town",
                    "City", "Large City", "Metropolis"}

--Resources: Food, Materials, Weapons
function City:addResources(dRes)
  self.nFood = self.nFood + dRes[1]
  self.nMat = self.nMat + dRes[2]
  self.nMil = self.nMil +dRes[3]

end

function City:getResources()
  bundle = {self.nFood, self.nMat, self.nMil}
  return bundle
end

--Equivalent to a constructor
function City.new(x, y, level, nMen, nWomen, nChildren)
  nu = setmetatable({}, { __index = City })
  nu.x = x
  nu.y = y
  nu.level = level
  nu.nMen = nMen
  nu.nWomen = nWomen
  nu.nChildren = nChildren
  nu.pop = nMen + nWomen + nChildren
  nu.width = 64
  nu.height = 64
  nu.name = getCityName()
  nu.nFood = 100
  nu.nMat = 100
  nu.nMil = 100
  nu.productionTime = 30
  nu.timer = nu.productionTime
  nu.sprite = love.graphics.newImage("res/teepee.png")
  nu.font = love.graphics.newFont(14)
  return nu
end

function City:update(dt)
  self.timer = self.timer - dt
  if self.timer <= 0 then
    self.timer = self.productionTime
    --eat food and produce materials
    self.nFood = self.nFood - self.pop
    self.nMil = self.nMil + self.nMen
  end
end

function City:templateText()
  return CityTypeStrings[self.level] .. " of " .. self.name .. "\nPopulation: " .. self.pop ..
          "\n    Idle Men: " .. self.nMen .. "\n    Idle Women " .. self.nWomen ..
          "\n    Idle Children: " .. self.nChildren .. "\nProduction: " ..
          "\n    Materials: " .. self.nMen*2
end

function City:draw()
  love.graphics.setColor(255, 255, 255)
  if self.level > 1 then
    love.graphics.draw(self.sprite, self.x, self.y, 0, 2, 2)
  else
    self:drawHamlet()
  end
end

function City:drawText()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(self.font)
  local text = self.nMen .. " " .. self.nWomen .. " " .. self.nChildren .. "\n" .. self.name
  love.graphics.print(text, self.x + 5, self.y + self.height - 10) 
  love.graphics.setNewFont()
  
end


function City:drawHamlet()
    love.graphics.draw(self.sprite, self.x + 32, self.y, 0, 0.8, 0.8)
    love.graphics.draw(self.sprite, self.x + 8 + 32, self.y + 8, 0, -1.0, 1.0)
    love.graphics.draw(self.sprite, self.x + 24, self.y + 16, 0, 1.2, 1.2)
end

