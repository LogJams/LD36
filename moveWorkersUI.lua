require "button"

MoveWorkers = {visible = true, font = love.graphics.newFont(25), currentResource = nil,
                x = 100, y = 100, w = 100, h = 120, bodyFont = love.graphics.newFont()}

MoveWorkers.buttons = {
                        Button.new(MoveWorkers.x + 68, MoveWorkers.y + 55, 10, 10, "<"),
                        Button.new(MoveWorkers.x + 97, MoveWorkers.y + 55, 10, 10, ">"),
                        Button.new(MoveWorkers.x + 129, MoveWorkers.y + 55, 10, 10, "<"),
                        Button.new(MoveWorkers.x + 156, MoveWorkers.y + 55, 10, 10, ">"),
                        Button.new(MoveWorkers.x + 192, MoveWorkers.y + 55, 10, 10, "<"),
                        Button.new(MoveWorkers.x + 220, MoveWorkers.y + 55, 10, 10, ">"),
                        Button.new(MoveWorkers.x, MoveWorkers.y + 1, 10, 10, "X")
                      }

function MoveWorkers.update(dt)
  for i = 1,#MoveWorkers.buttons do
    MoveWorkers.buttons[i]:update(mousex, mousey, leftClick)
  end
  MoveWorkers.visible = MoveWorkers.currentResource ~= nil
  if MoveWorkers.visible and leftClick then

    --increment/decrement workers with buttons
    if MoveWorkers.buttons[1].hover then      --increment men
      MoveWorkers.currentResource:tryRemove(0)
    elseif MoveWorkers.buttons[2].hover then  --decrement men
      MoveWorkers.currentResource:tryAdd(0)
    elseif MoveWorkers.buttons[3].hover then  --increment women
      MoveWorkers.currentResource:tryRemove(1)
    elseif MoveWorkers.buttons[4].hover then  --decrement women
      MoveWorkers.currentResource:tryAdd(1)
    elseif MoveWorkers.buttons[5].hover then  --increment children
      MoveWorkers.currentResource:tryRemove(2)
    elseif MoveWorkers.buttons[6].hover then   --decrement children
      MoveWorkers.currentResource:tryAdd(2)
    elseif MoveWorkers.buttons[7].hover then   --close window
      MoveWorkers.hide()
    end  
    
  end  
end

function MoveWorkers.isHover()
  return MoveWorkers.visible and (mousex > MoveWorkers.x and mousex < MoveWorkers.x + MoveWorkers.w  and
                                  mousey > MoveWorkers.y and mousey < MoveWorkers.y + MoveWorkers.h)
end

function MoveWorkers.setResource(res)
    MoveWorkers.currentResource = res
    MoveWorkers.visible = true
end

function MoveWorkers.hide()
  MoveWorkers.currentResource = nil
  MoveWorkers.visible = false
end

function MoveWorkers.draw()
  if MoveWorkers.visible and MoveWorkers.currentResource ~= nil then
    
    -- header
    local res = MoveWorkers.currentResource
    local titleText = res.name .. " --- " .. res.typeName
    -- draw a block
    local textWidth = MoveWorkers.font:getWidth(titleText) + 10
    local minWidth = math.max(300, textWidth)
    MoveWorkers.w = minWidth
    local xOff = (minWidth - textWidth)/2 + 5
    -- draw a block
    love.graphics.setColor(200, 200, 200)
    love.graphics.rectangle("fill", MoveWorkers.x, MoveWorkers.y - 3, MoveWorkers.w, 35)
    -- draw title bar text
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(MoveWorkers.font)
    love.graphics.print(titleText, MoveWorkers.x + xOff, MoveWorkers.y) 
    love.graphics.setNewFont()
    
    --draw the main body box
    love.graphics.setColor(170, 170, 170)
    love.graphics.rectangle("fill", MoveWorkers.x, MoveWorkers.y + 32, minWidth, MoveWorkers.h-35)
    --draw main body text
    love.graphics.setColor(0, 0, 0)
    local text = "Men\t  Women\tChildren\tTotal"
    love.graphics.print(text, MoveWorkers.x + 75, MoveWorkers.y + 40) 
    local res = MoveWorkers.currentResource
    local text = " " .. res.nMen .. "\t\t\t  ".. res.nWomen .."\t\t\t ".. res.nChildren .."\t\t\t".. res.nMen + res.nWomen + res.nChildren
    love.graphics.print(text, MoveWorkers.x + 75, MoveWorkers.y + 55) 
    local F, M, W = res:getProduction()
    local coeff = res:getProductionCoeff()
    local text = "Food\t\t  +" .. coeff[1] .. "\t\t  +" .. coeff[4] .. "\t\t  +" .. coeff[7] .. "\t\t   " .. F ..
                 "\nMaterials   +" .. coeff[2] .. "\t\t  +" .. coeff[5] .. "\t\t  +" .. coeff[8] .. "\t\t   " .. M ..
                 "\nWeapons   +" .. coeff[3] .. "\t\t  +" .. coeff[6] .. "\t\t  +" .. coeff[9] .. "\t\t   " .. W
    love.graphics.print(text, MoveWorkers.x + 10, MoveWorkers.y + 70) 
    for i = 1,#MoveWorkers.buttons do
      MoveWorkers.buttons[i]:draw()
    end
  end
end