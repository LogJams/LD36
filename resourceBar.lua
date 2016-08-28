ResourceBar = {}


function ResourceBar.isHover()
  return false
end

function ResourceBar.update(dt)
  
  
  
end


function ResourceBar.draw(nRes)
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle("fill", 0, 0, 100, 50)
  love.graphics.setColor(255, 255, 255)
  local text = "Food: " .. math.floor(nRes[1]) ..
        "\nMaterials: " .. math.floor(nRes[2]) .. 
        "\nSupplies " .. math.floor(nRes[3])
  love.graphics.print(text, 0, 0)  
  love.graphics.setColor(110, 110, 110)
  love.graphics.rectangle("fill", 100, 0, 50, 50)
  love.graphics.setColor(255, 255, 255)
  
  local f, m, w = world:getTotalProduction()
  f = f - homeCity:getConsumption()
  
  if f >= 0 then
    text = "+"
  else
    text = "-"
  end
  
  text = text .. " " .. math.abs(f) ..
        "\n+ " .. m .. 
        "\n+ " .. w
  love.graphics.print(text, 100, 0)  
end