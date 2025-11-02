-- config/characters.lua
-- Define per-class sprite sheet and animations
-- Row (x in frames) = direction (1=down, 2=up, 3=left, 4=right)
-- Col (y in frames) = animation frames
-- Stats: hp  = health points
--        pwr = multiplier for action strength
--        def = points reduced from incoming damage
--        dex = multiplier for accuracy and evasion
--        spd = influences movement speed and turn order
--        rng = range of attack
return {
  ninjaBlack = {
    path="assets/sprites/chars/ninjaBlack/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  gladiatorBlue = {
    path="assets/sprites/chars/gladiatorBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=7, def=5, dex=2, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.025 },
    }
  },

  -- Ninjas
  ninjaBlue = {
    path="assets/sprites/chars/ninjaBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  ninjaRed = {
    path="assets/sprites/chars/ninjaRed/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  ninjaGreen = {
    path="assets/sprites/chars/ninjaGreen/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  ninjaGray = {
    path="assets/sprites/chars/ninjaGray/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  ninjaYellow = {
    path="assets/sprites/chars/ninjaYellow/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  ninjaMasked = {
    path="assets/sprites/chars/ninjaMasked/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  ninjaBomb = {
    path="assets/sprites/chars/ninjaBomb/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  ninjaEskimo = {
    path="assets/sprites/chars/ninjaEskimo/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=2, dex=5, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  -- Samurai
  samuraiBlue = {
    path="assets/sprites/chars/samuraiBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=3, dex=4, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.01 },
    }
  },
  samuraiRed = {
    path="assets/sprites/chars/samuraiRed/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=3, dex=4, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.01 },
    }
  },
  samuraiArmoredBlue = {
    path="assets/sprites/chars/samuraiArmoredBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=30, pwr=6, def=6, dex=3, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.01 },
    }
  },
  samuraiArmoredRed = {
    path="assets/sprites/chars/samuraiArmoredRed/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=30, pwr=6, def=6, dex=3, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.01 },
    }
  },
  samuraiRedAlt = {
    path="assets/sprites/chars/samuraiRedAlt/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=3, dex=4, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.01 },
    }
  },

  -- Fighters
  fighterBlue = {
    path="assets/sprites/chars/fighterBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=3, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },
  fighterBlueAlt = {
    path="assets/sprites/chars/fighterBlueAlt/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=3, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },
  fighterRed = {
    path="assets/sprites/chars/fighterRed/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=3, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },

  -- Brawlers
  brawlerBlue = {
    path="assets/sprites/chars/brawlerBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=30, pwr=8, def=4, dex=2, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.03 },
    }
  },
  brawlerRed = {
    path="assets/sprites/chars/brawlerRed/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=30, pwr=8, def=4, dex=2, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.03 },
    }
  },

  -- Knights
  knightSilver = {
    path="assets/sprites/chars/knightSilver/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=30, pwr=7, def=7, dex=2, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.025 },
    }
  },
  knightGold = {
    path="assets/sprites/chars/knightGold/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=35, pwr=8, def=8, dex=2, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.025 },
    }
  },

  -- Mages
  mageBlack = {
    path="assets/sprites/chars/mageBlack/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=20, pwr=4, def=1, dex=4, spd=3, rng=3 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  mageOrange = {
    path="assets/sprites/chars/mageOrange/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=20, pwr=4, def=1, dex=4, spd=3, rng=3 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  -- Sorcerers
  sorcererBlack = {
    path="assets/sprites/chars/sorcererBlack/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=20, pwr=5, def=1, dex=4, spd=3, rng=4 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  sorcererOrange = {
    path="assets/sprites/chars/sorcererOrange/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=20, pwr=5, def=1, dex=4, spd=3, rng=4 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  -- Shamans
  shaman = {
    path="assets/sprites/chars/shaman/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=20, pwr=3, def=2, dex=4, spd=3, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  shaLion = {
    path="assets/sprites/chars/shaLion/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=4, def=3, dex=4, spd=3, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  -- Scouts
  scout = {
    path="assets/sprites/chars/scout/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=20, pwr=4, def=1, dex=6, spd=5, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  -- Sultans
  sultanBlack = {
    path="assets/sprites/chars/sultanBlack/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=4, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },
  sultanWhite = {
    path="assets/sprites/chars/sultanWhite/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=4, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },

  -- Tengu
  tenguBlue = {
    path="assets/sprites/chars/tenguBlue/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=3, dex=4, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },
  tenguRed = {
    path="assets/sprites/chars/tenguRed/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=5, def=3, dex=4, spd=4, rng=2 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.005 },
    }
  },

  -- Vampires
  vampire = {
    path="assets/sprites/chars/vampire/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=30, pwr=7, def=2, dex=4, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.015 },
    }
  },

  -- Lions
  lionOrange = {
    path="assets/sprites/chars/lionOrange/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=4, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },
  lionYellow = {
    path="assets/sprites/chars/lionYellow/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=4, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },
  lionDude = {
    path="assets/sprites/chars/lionDude/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=4, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },
  lionBro = {
    path="assets/sprites/chars/lionBro/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=6, def=4, dex=3, spd=3, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.02 },
    }
  },

  -- Gladiators
  gladiatorRed = {
    path="assets/sprites/chars/gladiatorRed/SpriteSheet.png", frameW=16, frameH=16,
    stats = { hp=25, pwr=7, def=5, dex=2, spd=2, rng=1 },
    animations = {
      idle   = { cols=1, duration=1 },
      walk   = { cols="1-4", duration=0.15 },
      attack = { cols=5, duration=0.025 },
    }
  },
}
