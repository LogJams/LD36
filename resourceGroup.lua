require "names"
--resource group is an entire forest/stone/grass/river
ResourceGroup = {}

--production rates for each type of tyle
--             Men {F, M, W} Women{F, M, W} Children{F, M, W}
ForestProduction = {3, 1, 0,       2, 2, 0,          1, 1, 0} --hunting, gathering, wandering??
StoneProduction  = {0, 4, 0,       1, 3, 0,          1, 1, 0} --mining,  gathering, wandering??
GrassProduction  = {2, 2, 0,       4, 0, 0,          1, 1, 0} --scavenging, farming, gardening??
RiverProduction  = {4, 0, 0,       1, 3, 0,          1, 1, 0} --fishing, scavenging, wandering??

ProductionNums = {GrassProduction, ForestProduction, StoneProduction, RiverProduction}


function ResourceGroup.new(id, index)
  nu = setmetatable({}, { __index = ResourceGroup })
  nu.id = id
  nu.index = index
  nu.size = 0
  nu.tiles = {}
  nu.name = getTerrainName(id)
  nu.nMen = 0
  nu.nWomen = 0
  nu.nChildren = 0
  nu.productionTime = 30 --time to produce something
  nu.timer = 0--nu.productionTime
  nu.owner = 1 -- everything is player owned!
  nu.x = 0
  nu.y = 0
  nu.typeName = resourceName(id)
  --some of this should go in a factory perhaps
  return nu 
end

function ResourceGroup:addWorker(workerType)
  if workerType == 0 then
    self.nMen = self.nMen + 1
  elseif workerType == 1 then
    self.nWomen = self.nWomen + 1
  else
    self.nChildren = self.nChildren + 1
  end
end
  
function ResourceGroup:tryAdd(workerType)
  if workerType == 0 then
    if homeCity.nMen > 0 then
      self.nMen = self.nMen + 1
      homeCity.nMen = homeCity.nMen - 1
    end
  elseif workerType == 1 then
    if homeCity.nWomen > 0 then
      self.nWomen = self.nWomen + 1
      homeCity.nWomen = homeCity.nWomen - 1
    end
  else
    if homeCity.nChildren > 0 then
      self.nChildren = self.nChildren + 1
      homeCity.nChildren = homeCity.nChildren - 1
    end
  end  
end


function ResourceGroup:tryRemove(workerType)
  if workerType == 0 then
    if self.nMen > 0 then
      self.nMen = self.nMen - 1
      homeCity.nMen = homeCity.nMen + 1
    end
  elseif workerType == 1 then
    if self.nWomen > 0 then
      self.nWomen = self.nWomen - 1
      homeCity.nWomen = homeCity.nWomen + 1
    end
  else
    if self.nChildren > 0 then
      self.nChildren = self.nChildren - 1
      homeCity.nChildren = homeCity.nChildren + 1
    end
  end  
end

function ResourceGroup:isFull()
  return self.nMen + self.nWomen + self.nChildren >= self.size
end

function ResourceGroup:addTile(tile)
  self.size = self.size + 1
  table.insert(nu.tiles, tile)
  tile.name = self.name
  tile.parent = self
  self.x = tile.x + tile.size/(tileSize/2) + self.x
  self.y = tile.y + tile.size/(tileSize/2) + self.y
end

function ResourceGroup:getTooltip()
  return self.name .. "\nWorkers: " .. self.nMen+self.nWomen + self.nChildren ..
          "/" .. self.size ..
          "\n    Men: " .. self.nMen .. "\n    Women: " .. self.nWomen ..
          "\n    Children: " .. self.nChildren ..
          "\nProduction:" .. self:getProductionString()
end

function ResourceGroup:drawText()
  love.graphics.setColor(0, 0, 0)
 -- love.graphics.setFont(self.font)
  local text = self.nMen + self.nWomen + self.nChildren .. "/" .. self.size
  love.graphics.print(text, self.x/self.size*tileSize + 50, self.y/self.size*tileSize) 
  love.graphics.setNewFont()
end

function ResourceGroup:getProductionString()
    prod = ProductionNums[self.id]
    dFood = prod[1] * self.nMen + prod[4] * self.nWomen + prod[7] * self.nChildren
    dMats = prod[2] * self.nMen + prod[5] * self.nWomen + prod[8] * self.nChildren
    dWeap = prod[3] * self.nMen + prod[6] * self.nWomen + prod[9] * self.nChildren
  return "\n    Food: " .. dFood .. "\n    Materials: " .. dMats .. "\n    Weapons: " .. dWeap
end

function ResourceGroup:getProduction()
  prod = ProductionNums[self.id]
  dFood = prod[1] * self.nMen + prod[4] * self.nWomen + prod[7] * self.nChildren
  dMats = prod[2] * self.nMen + prod[5] * self.nWomen + prod[8] * self.nChildren
  dWeap = prod[3] * self.nMen + prod[6] * self.nWomen + prod[9] * self.nChildren
  return dFood, dMats, dWeap
end

function ResourceGroup:getProductionCoeff()
  return ProductionNums[self.id]
end

--Resources: Food, Construction, Weapons
function ResourceGroup:update(dt)
  dFood = 0
  dMats = 0
  dWeap = 0
  self.timer = self.timer - dt
  if self.timer <= 0 then
    prod = ProductionNums[self.id]
    
    dFood = prod[1] * self.nMen + prod[4] * self.nWomen + prod[7] * self.nChildren
    dMats = prod[2] * self.nMen + prod[5] * self.nWomen + prod[8] * self.nChildren
    dWeap = prod[3] * self.nMen + prod[6] * self.nWomen + prod[9] * self.nChildren
    self.timer = self.productionTime
  end
  tmp = {dFood, dMats, dWeap}
  return tmp
end