Resource = {}


function Resource.new(x, y, id, index)
  nu = setmetatable({}, { __index = Resource })
  nu.x = x
  nu.y = y
  nu.id = id
  nu.index = index
  nu.size = 1
  return nu 
end


function Resource:merge(tiles, width)
  update = false
  for i = -1,1 do
    for j = -1,1 do
      if not(i == 0 and j == 0) then
        --merge tiles if their id is the same
        index = (i+self.x)+(j+self.y)*width + 1
        other = tiles[index]
        
        if other.id == self.id then
          update = (other.index ~= self.index) or update
          newIndex = math.min(other.index, self.index)
          
          thisLower = other.index > self.index
          
          other.index = newIndex
          self.index = newIndex
        end
      end
    end
  end
  return update
end