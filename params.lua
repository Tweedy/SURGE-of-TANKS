local params = {}

params.pause = false
params.stats_debug = false

  
------------------------------------------ FONCTIONS ---------------------------------------------------------

-- Renvoie l'angle entre deux vecteurs ayant la même origine.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function Collide(a1, a2) -- Permet de calculer le point de collision
  local a1L = a1.width*a1.scaleX
  local a1H = a1.height*a1.scaleY
  local a2L = a2.width*a2.scaleX
  local a2H = a2.height*a2.scaleY
  if a1 == a2 then
    return false
  end
  if a1.x-(a1L/2) < a2.x-(a2L/2) + a2L and 
     a1.x + a1L > a2.x-(a2L/2) and
     a1.y < a2.y + a2H-(a2H/2) and
     a1.y + a1H > a2.y-(a2H/2) then
    return true
  end 
end

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