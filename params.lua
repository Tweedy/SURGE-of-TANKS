local params = {}

params.pause = false
params.stats_debug = false

  

  function Ecran()
    love.window.setMode(1024,768)
    love.window.setTitle("Atelier Shooter Gamecodeur")
    
    LARGEUR_ECRAN = love.graphics.getWidth()
    HAUTEUR_ECRAN = love.graphics.getHeight()
  end
  
  function math.dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
  end
return params