CityNames = {"Calixtlahuaca", "Chacchoben",
            "Dzibilchaltun", "Ek Balam", "Xochicalco"}
          
function getCityName()
  return CityNames[math.random(#CityNames)]
end

-- G F S W
GrassNames = {"Alpaca Fields", "Greenlands",
              "Kakax Fields", "Qredit Meadow", "Walaf Prarie",}
ForestNames = {"Shaggy Maple Woods", "Tundra Crab Forest",
              "Ons Thicket", "Grajyrt Covet", "Spectral Woodlands"}
StoneNames = {"Grim Peaks", "Tedehsh Highland", "Aekx Pinnacles",
              "Urc Bluffs", "Rocky Slopes", "Wyp Heights"}
WaterNames = {"Calm Run", "Rozus River", "Crals Channel",
              "Qiihst Rill", "Pleasant Brook", "Muylm Creek"}
            
terrainFunctions = {function() return GrassNames[math.random(#GrassNames)] end,
                    function() return ForestNames[math.random(#ForestNames)] end,
                    function() return StoneNames[math.random(#StoneNames)] end,
                    function() return WaterNames[math.random(#WaterNames)] end}
function getTerrainName(id)
  return terrainFunctions[id]()
end
