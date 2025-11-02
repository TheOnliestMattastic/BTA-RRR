-- config/fx.lua
-- Defines effect animations for combat and spells
-- Each entry: path (asset location), frameW/H (sprite dimensions), frames (anim8 syntax), duration (seconds per frame)

return {
  -- Basic melee attacks
  slash            		= { path = "assets/sprites/fx/slash.png",                 frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  slashCircular    		= { path = "assets/sprites/fx/slashCircular.png",         frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  slashCurved      		= { path = "assets/sprites/fx/slashCurved.png",           frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  slashDouble      		= { path = "assets/sprites/fx/slashDouble.png",           frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  slashDoubleCurved		= { path = "assets/sprites/fx/slashDoubleCurved.png",	  frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  claw             		= { path = "assets/sprites/fx/claw.png",                  frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  clawDouble       		= { path = "assets/sprites/fx/clawDouble.png",            frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  cut              		= { path = "assets/sprites/fx/cut.png",                   frameW = 32, frameH = 32, frames = { "1-5", 1 }, duration = 0.07 },

  -- Projectiles and thrown weapons
  kunai            		= { path = "assets/sprites/fx/kunai.png",                 frameW = 65, frameH = 59, frames = { "1-10", 1 }, duration = 0.07 },
  shuriken         		= { path = "assets/sprites/fx/shuriken.png",              frameW = 69, frameH = 54, frames = { "1-10", 1 }, duration = 0.07 },
  energyBall       		= { path = "assets/sprites/fx/energyBall.png",            frameW = 16, frameH = 16, frames = { "1-4", 1 }, duration = 0.07 },

  -- Healing and support effects
  heal             		= { path = "assets/sprites/fx/heal.png",                  frameW = 32, frameH = 32, frames = { "1-5", 1 }, duration = 0.07 },
  healDouble       		= { path = "assets/sprites/fx/healDouble.png",            frameW = 32, frameH = 32, frames = { "1-5", 1 }, duration = 0.07 },
  aura             		= { path = "assets/sprites/fx/aura.png",                  frameW = 25, frameH = 24, frames = { "1-5", 1 }, duration = 0.07 },
  boost            		= { path = "assets/sprites/fx/boost.png",                 frameW = 53, frameH = 35, frames = { "1-8", 1 }, duration = 0.07 },

  -- Defensive effects
  shieldBlue       		= { path = "assets/sprites/fx/shieldBlue.png",            frameW = 24, frameH = 26, frames = { "1-6", 1 }, duration = 0.07 },
  shieldYellow     		= { path = "assets/sprites/fx/shieldYellow.png",          frameW = 24, frameH = 26, frames = { "1-6", 1 }, duration = 0.07 },

  -- Elemental effects
  fire             		= { path = "assets/sprites/fx/fire.png",                  frameW = 25, frameH = 30, frames = { "1-8", 1 }, duration = 0.07 },
  fireBall         		= { path = "assets/sprites/fx/fireBall.png",              frameW = 16, frameH = 16, frames = { "1-4", 1 }, duration = 0.07 },
  water            		= { path = "assets/sprites/fx/water.png",                 frameW = 40, frameH = 33, frames = { "1-11", 1 }, duration = 0.07 },
  waterAlt         		= { path = "assets/sprites/fx/waterAlt.png",              frameW = 30, frameH = 41, frames = { "1-9", 1 }, duration = 0.07 },
  ice              		= { path = "assets/sprites/fx/ice.png",                   frameW = 32, frameH = 32, frames = { "1-10", 1 }, duration = 0.07 },
  iceAlt           		= { path = "assets/sprites/fx/iceAlt.png",                frameW = 32, frameH = 32, frames = { "1-9", 1 }, duration = 0.07 },
  iceSpike         		= { path = "assets/sprites/fx/iceSpike.png",              frameW = 16, frameH = 10, frames = { "1-9", 1 }, duration = 0.07 },
  thunder          		= { path = "assets/sprites/fx/thunder.png",               frameW = 32, frameH = 28, frames = { "1-5", 1 }, duration = 0.07 },
  rock             		= { path = "assets/sprites/fx/rock.png",                  frameW = 30, frameH = 30, frames = { "1-14", 1 }, duration = 0.07 },
  rockAlt          		= { path = "assets/sprites/fx/rockAlt.png",               frameW = 30, frameH = 30, frames = { "1-14", 1 }, duration = 0.07 },
  rockSpike        		= { path = "assets/sprites/fx/rockSpike.png",             frameW = 54, frameH = 48, frames = { "1-10", 1 }, duration = 0.07 },
  plant            		= { path = "assets/sprites/fx/plant.png",                 frameW = 30, frameH = 28, frames = { "1-8", 1 }, duration = 0.07 },
  plantAlt         		= { path = "assets/sprites/fx/plantAlt.png",              frameW = 30, frameH = 26, frames = { "1-7", 1 }, duration = 0.07 },
  plantSpike       		= { path = "assets/sprites/fx/plantSpike.png",            frameW = 24, frameH = 20, frames = { "1-4", 1 }, duration = 0.07 },

  -- Miscellaneous 		ects
  explosion        		= { path = "assets/sprites/fx/explosion.png",             frameW = 40, frameH = 40, frames = { "1-9", 1 }, duration = 0.07 },
  sparkle          		= { path = "assets/sprites/fx/sparkle.png",               frameW = 27, frameH = 35, frames = { "1-10", 1 }, duration = 0.07 },
  smoke            		= { path = "assets/sprites/fx/smoke.png",                 frameW = 32, frameH = 32, frames = { "1-6", 1 }, duration = 0.07 },
  smokeImpact      		= { path = "assets/sprites/fx/smokeImpact.png",           frameW = 30, frameH = 14, frames = { "1-8", 1 }, duration = 0.07 },
  pointAlt         		= { path = "assets/sprites/fx/pointAlt.png",              frameW = 32, frameH = 32, frames = { "1-6", 1 }, duration = 0.07 },
  pointWhite       		= { path = "assets/sprites/fx/pointWhite.png",            frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
  pointOrange      		= { path = "assets/sprites/fx/pointOrange.png",           frameW = 32, frameH = 32, frames = { "1-4", 1 }, duration = 0.07 },
}
