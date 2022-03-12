local params = {}

params.pause = false
params.stats_debug = false

  

  function Ecran()
    love.window.setMode(1024,768)
    love.window.setTitle("Atelier Shooter Gamecodeur")
    
    LARGEUR_ECRAN = love.graphics.getWidth()
    HAUTEUR_ECRAN = love.graphics.getHeight()
  end

return params