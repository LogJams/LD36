require "city"
require "world"
require "tooltip"
require "ui"

Cities = {} --all existing cities


--input section
leftClick = false
rightClick = false

function love.mousereleased(x, y, button)
  if button == 1 then
    leftClick = true
  elseif button == 2 then
    rightClick = true
  end
end

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest")
  -- Load Image Resources --
  world = World.new()
  world:load()
  world:setup()
  Tooltip.setup()
  
  start()
end

function getCity(index)
  return Cities[index]
end

function start()
  love.graphics.setBackgroundColor(110, 139, 61)
  -- maybe background color should be something weird
  -- perhaps tile the map with some random noise to generate
  -- forests (construction/food), mud/desert/? (construction)
  -- volcanic (agriculture, weapons), quarry (construction, armor)
  
  -- initialize "objects" --
  homeCity = City.new(358, 250, 1, 6, 6, 8)
  table.insert(Cities, homeCity)
  
  end

function love.update(dt)
  --update cities
  for i = 1,#Cities do
    Cities[i]:update(dt)
  end
  --move people around on click
  mousex, mousey = love.mouse.getPosition()
  -- THIS SHOULD PROBABLY BE REPLACED WITH A GUI
  if leftClick then
    --if we're over some territory add any available man to it
    if homeCity.nMen > 0 then
      if world:addWorker(mousex, mousey, 0) then
        homeCity.nMen = homeCity.nMen - 1
      end
    elseif homeCity.nChildren > 0 then
      if world:addWorker(mousex, mousey, 2) then
        homeCity.nChildren = homeCity.nChildren - 1
      end
    end
  elseif rightClick then
    --if we're over some territory add any available woman to it
     if homeCity.nWomen > 0 then
      if world:addWorker(mousex, mousey, 1) then
        homeCity.nWomen = homeCity.nWomen - 1
      end
    elseif homeCity.nChildren > 0 then
      if world:addWorker(mousex, mousey, 2) then
        homeCity.nChildren = homeCity.nChildren - 1
      end
    end
  end
  -- update world/terrain
  world:update(dt)
  --update UI/tooltip  
  --if the mouse is over a city then use that for the text
  if mousex > homeCity.x and mousex < homeCity.x + homeCity.width  and
     mousey > homeCity.y and mousey < homeCity.y + homeCity.height then
    Tooltip.text = homeCity:templateText()
    --else if a city was clicked set something to true
    --else display information about the current tile
  else
    Tooltip.text = world:getTooltip(mousex, mousey)
  end
  Tooltip.update(dt)
  UI.update(dt)
  --set input to false
  leftClick = false
  rightClick = false

end

function love.draw()
  
  world:draw()
  homeCity:draw()
  
  world:drawText()
  homeCity:drawText()
  
  Tooltip.draw()
  UI.draw(homeCity:getResources())
  
end