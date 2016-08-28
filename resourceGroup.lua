require "names"
--resource group is an entire forest/quarry/field/river
ResourceGroup = {}

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
  

function ResourceGroup:isFull()
  return self.nMen + self.nWomen + self.nChildren >= self.size
end

function ResourceGroup:addTile(tile)
  self.size = self.size + 1
  table.insert(nu.tiles, tile)
  tile.name = self.name
  tile.parent = self
end

function ResourceGroup:getTooltip()
  return self.name .. "\nWorkers: " .. self.nMen+self.nWomen + self.nChildren ..
          "/" .. self.size ..
          "\n    Men: " .. self.nMen .. "\n    Women: " .. self.nWomen ..
          "\n    Children: " .. self.nChildren ..
          "\nProduction:\n    Food: ".. self.nMen + 2*self.nWomen ..
          "\n    Materials: " .. 2*self.nMen + self.nWomen --getProductionString()?
end

function ResourceGroup:drawText()
  love.graphics.setColor(0, 0, 0)
 -- love.graphics.setFont(self.font)
  local text = "0/30"
  love.graphics.print(text, self.x + 5, self.y + self.height - 10) 
  love.graphics.setNewFont()
end

--Resources: Food, Construction, Weapons
function ResourceGroup:update(dt)
  dFood = 0
  dMats = 0
  dWeap = 0
  self.timer = self.timer - dt
  if self.timer <= 0 then
    dFood = 1 * self.nMen + 2 * self.nWomen + 0.5 * self.nChildren
    dMats = 2 * self.nMen + 1 * self.nWomen + 0.5 * self.nChildren
    dWeap = 0
    self.timer = self.productionTime
  end
  tmp = {dFood, dMats, dWeap}
  return tmp
end