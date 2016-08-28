anim8 = require "anim8"
require "resource"
require "resourceGroup"

World = {}

width = 14
height = 10

tileSize = 64

--resource constants
resources = {}
G = 1
F = 2
S = 3
W = 4
--resource containers
grasslands = {}
forests = {}
stones = {}
waters = {}

resourceGroups = {}

function resourceName(id)
  text = "NotDefined"
  if id==G then
    text = "Grassland"
  elseif id == F then
    text = "Forest"
  elseif id == S then
    text = "Foothills"
  elseif id == W then
    text = "River"
  end
  return text
end

map = {F, F, F, F, F, W, G, G, G, G, G, G, S, S,
       F, F, F, F, F, W, G, G, G, G, G, G, S, S,
       F, F, F, F, W, W, G, G, G, G, G, G, S, S,
       F, F, F, F, W, G, G, G, G, G, G, G, S, S,
       F, F, F, F, W, G, G, G, G, G, G, S, S, S,
       F, F, F, W, W, G, G, G, G, G, G, S, S, S,
       F, F, F, W, G, G, G, G, G, S, S, S, S, S,
       F, F, F, W, G, G, G, G, S, S, S, S, S, S,
       F, F, W, G, G, G, S, S, S, S, S, S, S, S,
       F, F, W, G, G, G, S, S, S, S, S, S, S, S}

--Equivalent to a constructor
function World.new()
  return setmetatable({}, { __index = World })
end

function World:getTotalProduction()
  local F = 0
  local M = 0
  local W = 0
  for i = 1,#resourceGroups do
    local F2,M2,W2 = resourceGroups[i]:getProduction()
    F = F + F2
    M = M + M2
    W = W + W2
  end
  return F, M, W
end

function World:load()
  self.image = love.graphics.newImage('res/ground_tiles.png')
  --tiles are 64x64
  local g = anim8.newGrid(tileSize, tileSize, self.image:getWidth(), self.image:getHeight())
  self.animation = anim8.newAnimation(g('1-4', 1), 0.1);
end


function World:setup()
  -- set up the resources (forest, stone, etc)
  forestCt = 0
  stonceCt = 0
  grassCt = 0
  waterCt = 0
  for j = 0,height-1 do
    for i=0,width-1 do
      index = i+j*width + 1
      terrainType = map[index]
      num = 0
      if (terrainType == F) then
        num = forestCt
        forestCt = forestCt + 1
      elseif (terrainType == S) then
        num = stonceCt
        stonceCt = stonceCt + 1
      elseif (terrainType == W) then
        num = waterCt
        waterCt = waterCt + 1
      else
        num = grassCt
        grassCt = grassCt + 1
      end
      table.insert(resources, Resource.new(i,j,terrainType,num))
    end
  end
  -- merge all the resources into blobs
  merging = true
  while merging do
    merging = false
    for j = 1,height-2 do
      for i = 1,width-2 do
        index = i+j*width + 1
        merging = resources[index]:merge(resources, width) or merging
      end
    end
  end
  --get number of each resource type TODO so far there is only one!
  grassFound = false
  forestFound = false
  stoneFound = false
  waterFound = false
  for j = 0,height-1 do
    for i = 0,width-1 do
      index = i+j*width + 1
      tile = resources[index]
      if tile.id == G then
        if not grassFound then
          grasslands = ResourceGroup.new(tile.id, 0)
          grassFound = true
        end
        grasslands:addTile(tile)
        
      elseif tile.id == F then
        if not forestFound then
          forests = ResourceGroup.new(tile.id, 0)
          forestFound = true
        end
        forests:addTile(tile)

        
      elseif tile.id == S then
        if not stoneFound then
          stones = ResourceGroup.new(tile.id, 0)
          stoneFound = true
        end
        stones:addTile(tile)

      elseif tile.id == W then
        if not waterFound then
          waters = ResourceGroup.new(tile.id, 0)
          waterFound = true
        end
        waters:addTile(tile)

      end
    end
  end   
  resourceGroups = {grasslands, forests, stones, waters}
end

function World:getTooltip(mousex, mousey)
  return self:getResourceGroup(mousex, mousey):getTooltip()
end

function World:getResourceGroup(x, y)
  i = math.floor(x/tileSize)
  j = math.floor(y/tileSize)
  index = i+j*width + 1
  return resources[index].parent
end

--create a textual representation of the world
--then sample that map to select the texture using a... lookup table?
--based on the clicked tile do SOMETHING!
function World:addWorker(x, y, workerType) -- 0 is man, 1 is woman, 2 is child 
  res = self:getResourceGroup(x, y)
  if not(res:isFull()) then
    res:addWorker(workerType)
    return true
  else
    return false -- no space
  end
end


function World:update(dt)
  --should this ever update? maybe to add snow...
  for i = 1,#resourceGroups do    
    getCity(resourceGroups[i].owner):addResources(resourceGroups[i]:update(dt))
    
  end
end

function World:draw()
love.graphics.setColor(255, 255, 255)
  for i=0,width-1 do
    for j = 0,height-1 do
      index = i+j*width + 1
      self.animation:gotoFrame(map[index])
      self.animation:draw(world.image, i*tileSize, j*tileSize)
    end
  end  
end


function World:drawText()
  for i = 1,#resourceGroups do    
    resourceGroups[i]:drawText()
  end
end