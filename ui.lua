require "resourceBar"
require "moveWorkersUI"
require "button"
UI = {}


function UI.update(dt)
  ResourceBar.update(dt)
  MoveWorkers.update(dt)
  
end

function UI.close()
  MoveWorkers.hide()
  
end

function UI.draw(nRes)
  ResourceBar.draw(nRes)
  MoveWorkers.draw()
end

function UI.selectResource(res)
  MoveWorkers.setResource(res)
end

function UI.mouseHover()
  return MoveWorkers.isHover() or ResourceBar.isHover()
end