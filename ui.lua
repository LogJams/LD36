UI = {}


function UI.update(dt)
  
  
  
end


function UI.draw(nRes)
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle("fill", 0, 0, 100, 50)
  love.graphics.setColor(255, 255, 255)
  text = "Food: " .. math.floor(nRes[1]) ..
        "\nMaterials: " .. math.floor(nRes[2]) .. "\nSupplies " .. math.floor(nRes[3])
  love.graphics.print(text, 0, 0)  
end