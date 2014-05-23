local LevelsInfo = {} -- public interface
LevelsInfo.l = {}

LevelsInfo.numOfLevels = 2

-- Enemies optional fields: amount, health, damage, color, mass, speed, bulletAversion, startRandCount, randomThrust, randomRate, linearDamping, style, shooting: {standardShootingFields}, shield: {duration, cooldown, health}, spawnOnDead
-- Enemy #3 - approach
-- Enemy #4/5 - approach, counter, timeInRun, timeInSafe, dontShoot, shootingIfShot: {}

-- Items optional fields: color, upgrade (higher values take out lower value slots), boost: {speed, controlled}. shooting: {radial, standardShootingFields}, shield: {duration, cooldown, health}, frozen: {duration, cooldown, damp}, ship {}

-- Standard shooting fields: type, damage, rate, speed, number, angleSeperation, health, clipSize, mass, minSpeed, radius

-- Level options: minAlive, firingAngle, friendlyFire, pinballMode

-- Ship fields (unfinished) : torqueMult

-- Wall Fields : time, x, y, type, mass, doHide, timeDisplay, timeHide, movingTransparent, enemyTransparent, enemyBulletTransparent, friendlyTransparent,friendlyBulletTransparent, linearDamping, pairs

-- Level Ideas Order
    -- 1)  Introduce Guns - Randomly move, Straight line, Guns
    -- 2)  Gun on joystick - Friendly Fire
    -- 3)  Dodge Bullets - Introduce Freeze
    -- 4)  Guns shoot randomly - Bomb
    -- 5)  Get good guns
    -- 6)  Switch everyones controls with other people
    -- 7)  Introduce shield, boost
    -- 8)  All same color
    -- 9)  Walls
    -- 10) Walls 2
    -- 11) Pinball
    -- 12) Scary Shield shooting enemies
    -- 13) Drop Mines   ---Removed
    -- 14) Boss-man     ---Removed

LevelsInfo.l = {{ -- ) Introduce Guns - Randomly move, Straight line, Guns
    levelMessage = "Maybe focus on surviving for right now. Colors match buttons";
    enemies = {
        {time = 50;  x = 0.03;  y = .5;   amount = 0; type = 0; linearDamping = 0.5; randomThrust = 20000};
        {time = 50;  x = -0.03; y = .5;   amount = 0; type = 0; linearDamping = 0.5; randomThrust = 20000};
        {time = 50;  x = .5;    y = .03;  amount = 0; type = 0; linearDamping = 0.5; randomThrust = 20000};
        {time = 50;  x = .5;    y = -.03; amount = 0; type = 0; linearDamping = 0.5; randomThrust = 20000};
        {time = 100; x = .03;   y = .03;  amount = 2; type = 1;}; -- width = 30; height = 30};
        {time = 100; x = -.03;  y = .03;  amount = 2; type = 1;}; -- width = 30; height = 30};
        {time = 100; x = -.03;  y = -.03; amount = 2; type = 1;}; -- width = 30; height = 30};
        {time = 100; x = .03;   y = -.03; amount = 2; type = 1;}; -- width = 30; height = 30};
        {time = 250; x = .03;   y = .03;  amount = 2; type = 1;}; -- width = 30; height = 30};
        {time = 250; x = -.03;  y = .03;  amount = 2; type = 1;}; -- width = 30; height = 30};
        {time = 250; x = -.03;  y = -.03; amount = 2; type = 1;}; -- width = 30; height = 30};
        {time = 250; x = .03;   y = -.03; amount = 2; type = 1;}; -- width = 30; height = 30};
    };
    items = {
        -- {time = 100; x = .5; y = .5; button = "X"; shield = {}};
        {time = 150; x = .5; y = .5;  button = "A"; shooting = {rate = 6}};
        {time = 200; x = .45; y = .5; button = "A"; shooting = {rate = 6}};
        {time = 250; x = .5; y = .45; button = "A"; shooting = {rate = 6}};
        {time = 300; x = .55; y = .5; button = "A"; shooting = {rate = 6}};
        {time = 350; x = .5; y = .55; button = "A"; shooting = {rate = 6}};
    };
    -- audio = {{time = 300; source = "HelpFromHere"}};
    -- minAlive = 1;            --Optional
    firingAngle = math.pi;   --Optional
    -- friendlyFire = true;     --Optional
    minLevelLength = 600;
    -- pinballMode = true;     --Optional
};
{   -- ) Gun on joystick - Friendly Fire
    levelMessage = "Friendly Fire, white uses right joystick";
    enemies = {
        {time = 100; x=.5; y=.5; type=0; amount = 5; randomRate = 30; randomThrust = 20000; randomAddition = 1; linearDamping = 0};
--      {time = 100; x = 500; y = 700; type = 0; health = 200; shooting = {type = 1; clipSize = 10; rate = 40; angleSeperation = .05; number = 3}};
        {time = 140; x = 100;  y = 100;  amount = 3; type = 1; shooting = {}};
        {time = 140; x = -100; y = 100;  amount = 3; type = 1; shooting = {}};
        {time = 140; x = .5;   y = .5;   amount = 3; type = 1; shooting = {}};
        {time = 140; x = -100; y = -100; amount = 3; type = 1; shooting = {}};
        {time = 140; x = 100;  y = -100; amount = 3; type = 1; shooting = {}};
        {time = 490; x = 100;  y = 100;  amount = 3; type = 0; startRandCount = 49; linearDamping = 0.5; randomThrust = 20000};
        {time = 490; x = -100; y = 100;  amount = 3; type = 0; startRandCount = 49; linearDamping = 0.5; randomThrust = 20000};
        {time = 490; x = .5;   y = .5;   amount = 3; type = 0; startRandCount = 49; linearDamping = 0.5; randomThrust = 20000};
        {time = 490; x = -100; y = -100; amount = 3; type = 0; startRandCount = 49; linearDamping = 0.5; randomThrust = 20000};
        {time = 490; x = 100;  y = -100; amount = 3; type = 0; startRandCount = 49; linearDamping = 0.5; randomThrust = 20000};
    };
    items = {
        {time = 220; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        {time = 220; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        {time = 220; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        {time = 220; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        {time = 220; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    friendlyFire = true;    --Optional
    minLevelLength = 600;
    -- pinballMode =false;     --Optional
};
{   -- ) Dodge Bullets - Introduce Freeze
    levelMessage = "Fine. Just try and hit us now. Eject your items with D-pad and select.";
    enemies = {
        -- {time = 60; x = .5; y = .95; amount = 2; type = 4; style = "fill";};
        -- {time = 60; x = .5; y = .05; amount = 2; type = 0; width = 5; height = 5};
        -- {time = 30; x = 100; y = 100; amount = 5; type = 1; shooting = {rate = 100; mass = 10; number = 50; angleSeperation = math.pi/25; speed = 100000}};
        {time = 60; x = .5; y = .5; amount = 5; type = 1; shooting = {rate = 100; mass = 10; number = 10; angleSeperation = math.pi/25; speed = 100000}};

        {time = 70; x = 100; y = 100; amount = 5; type = 2; width = 20; height = 30; speed = 1600; bulletAversion = 150; linearDamping = 10};
        {time = 70; x = -100; y = 100; amount = 5; type = 2; width = 20; height = 30; speed = 1600; bulletAversion = 150; linearDamping = 10};
        {time = 70; x = -100; y = -100; amount = 5; type = 2; width = 20; height = 30; speed = 1600; bulletAversion = 150; linearDamping = 10};
        {time = 70; x = 100; y = -100; amount = 5; type = 2; width = 20; height = 30; speed = 1600; bulletAversion = 150; linearDamping = 10};

        {time = 270; x = 100; y = 100; amount = 5; type = 2; width = 20; height = 20; speed = 800; bulletAversion = 300; linearDamping = 10};
        {time = 270; x = -100; y = 100; amount = 5; type = 2; width = 20; height = 20; speed = 800; bulletAversion = 300; linearDamping = 10};
        {time = 270; x = -100; y = -100; amount = 5; type = 2; width = 20; height = 20; speed = 800; bulletAversion = 300; linearDamping = 10};
        {time = 270; x = 100; y = -100; amount = 5; type = 2; width = 20; height = 20; speed = 800; bulletAversion = 300; linearDamping = 10};
    };
    items = {
        -- {time = 100; x = .5; y = .5; button = "X"; shield = {}};
        {time = 140; x = .15;  y = .5; button = "B"; frozen = {}};
        {time = 140; x = -.15; y = .5; button = "B"; frozen = {}};
        {time = 160; x = .5; y = .5; button = "B"; frozen = {}};
        {time = 190; x = .5; y = .05; button = "B"; frozen = {}};
        {time = 190; x = .5; y = -.05; button = "B"; frozen = {}};
        -- {time = 400; x = .05; y = .05; button = "X"; boost = {}};
        -- {time = 450; x = -.05; y = .05; button = "X"; shooting = {rate = 30; damage = 300; type = 2}};
        -- {time = 500; x = .5; y = .5; button = "X"; shooting = {rate = 5}};
        -- {time = 550; x = -.05; y = -.05; button = "X"; shooting = {rate = 10; clipSize = 3;}};
        -- {time = 600; x = .05; y = -.05; button = "X"; shooting = {rate = 10; number = 3; angleSeperation = .15}};
    };
    -- audio = {{time = 300; source = "PauseProcesses"}};
    -- minAlive = 1;            --Optional
    -- firingAngle = math.pi;   --Optional
    -- friendlyFire = true;     --Optional
    minLevelLength = 600;
    -- pinballMode = true;     --Optional
};
{   -- ) Guns shoot randomly - Bomb
    levelMessage = "Ah, I fixed your pesky guns!";
    enemies = {
        {time=60; x=.5; y=.5; type=0; amount = 5; randomRate = 30; randomThrust = 20000; randomAddition = 1; linearDamping = 0};
--      {time = 60; x = 500; y = 700; type = 0; health = 200; shooting = {type = 1; clipSize = 10; rate = 40; angleSeperation = .05; number = 3}};
        {time = 100; x = 100;  y = 100;  amount = 3; type = 1; shooting = {}};
        {time = 100; x = -100; y = 100;  amount = 3; type = 1; shooting = {}};
        {time = 100; x = .5;   y = .5;   amount = 3; type = 1; shooting = {}};
        {time = 100; x = -100; y = -100; amount = 3; type = 1; shooting = {}};
        {time = 100; x = 100;  y = -100; amount = 3; type = 1; shooting = {}};

        {time = 450; x = 100;  y = 100;  amount = 3; type = 0; startRandCount = 49; shooting = {}};
        {time = 450; x = -100; y = 100;  amount = 3; type = 0; startRandCount = 49; shooting = {}};
        {time = 450; x = .5;   y = .5;   amount = 3; type = 0; startRandCount = 49; shooting = {}};
        {time = 450; x = -100; y = -100; amount = 3; type = 0; startRandCount = 49; shooting = {}};
        {time = 450; x = 100;  y = -100; amount = 3; type = 0; startRandCount = 49; shooting = {}};
    };
    items = {
        {time = 220; x = .5; y = -.05;   button = "Y";  shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180; }};--audio = "bigBoom"}};
        {time = 220; x = .5; y = .05;    button = "Y";  shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180; }};--audio = "bigBoom"}};
        {time = 260; x = .05; y = .05;   button = "Y";  shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180; }};--audio = "bigBoom"}};
        {time = 260; x = -.05; y = .05;  button = "Y";  shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180; }};--audio = "bigBoom"}};
        {time = 260; x = .05; y = -.05;  button = "Y";  shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180; }};--audio = "bigBoom"}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    -- friendlyFire = true;     --Optional
    minLevelLength = 600;
    randomFiringAngle = true    --Optional
    -- pinballMode =false;     --Optional
};
{   -- ) Get good guns
    levelMessage = "... I don't like those bombs Jarvis got you.";
    enemies = {
        {time=60; x=.5; y=.5; type=0; amount = 5; randomRate = 30; randomThrust = 20000; randomAddition = 1; linearDamping = 0};
--      {time = 60; x = 500; y = 700; type = 0; health = 200; shooting = {type = 1; clipSize = 10; rate = 40; angleSeperation = .05; number = 3}};
        {time = 100; x = 100;  y = 100;  amount = 2; type = 1; shooting = {}};
        {time = 100; x = -100; y = 100;  amount = 2; type = 1; shooting = {}};
        {time = 100; x = .5;   y = .5;   amount = 2; type = 1; shooting = {}};
        {time = 100; x = -100; y = -100; amount = 2; type = 1; shooting = {}};
        {time = 100; x = 100;  y = -100; amount = 2; type = 1; shooting = {}};

        {time = 450; x = 100;  y = 100;  amount = 4; type = 0; startRandCount = 30; shooting = {rate = 30}};
        {time = 450; x = -100; y = 100;  amount = 4; type = 0; startRandCount = 30; shooting = {rate = 30}};
        {time = 450; x = .5;   y = .5;   amount = 4; type = 0; startRandCount = 30; shooting = {rate = 30}};
        {time = 450; x = -100; y = -100; amount = 4; type = 0; startRandCount = 30; shooting = {rate = 30}};
        {time = 450; x = 100;  y = -100; amount = 4; type = 0; startRandCount = 30; shooting = {rate = 30}};
    };
    items = {
        {time = 200; x = .5; y = .5;  upgrade = 1; button = "R"; shooting = {rate = 3}};
        {time = 250; x = .45; y = .5; upgrade = 1; button = "R"; shooting = {rate = 10; clipSize = 4;}};
        {time = 300; x = .5; y = .45; upgrade = 1; button = "R"; shooting = {rate = 10; number = 5; angleSeperation = .1}};
        {time = 350; x = .55; y = .5; upgrade = 1; button = "R"; shooting = {rate = 30; number = 15; angleSeperation = .02}};
        {time = 400; x = .5; y = .55; upgrade = 1; button = "R"; shooting = {rate = 30; clipSize = 4; number = 6; angleSeperation = .03}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    -- friendlyFire = true;     --Optional
    minLevelLength = 600;
    -- randomFiringAngle = true    --Optional
    -- pinballMode =false;     --Optional
};
{   -- 6)  Switch everyones controls with other people
    levelMessage = "Who are you again?";
    enemies = {
        {time=60; x=.5; y=.5; type=0; amount = 5; randomRate = 30; randomThrust = 20000; randomAddition = 1; linearDamping = 0};
--      {time = 60; x = 500; y = 700; type = 0; health = 200; shooting = {type = 1; clipSize = 10; rate = 40; angleSeperation = .05; number = 3}};
        {time = 100; x = 100;  y = 100;  amount = 3; type = 1; shooting = {}};
        {time = 100; x = -100; y = 100;  amount = 3; type = 1; shooting = {}};
        {time = 100; x = .5;   y = .5;   amount = 3; type = 1; shooting = {}};
        {time = 100; x = -100; y = -100; amount = 3; type = 1; shooting = {}};
        {time = 100; x = 100;  y = -100; amount = 3; type = 1; shooting = {}};

        {time = 100; x = 100;  y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = -100; y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = .5;   y = .5;   amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = -100; y = -100; amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = 100;  y = -100; amount = 3; type = 3; shooting = {rate = 20}};

        {time = 250; x = 100;  y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 250; x = -100; y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 250; x = .5;   y = .5;   amount = 3; type = 3; shooting = {rate = 20}};
        {time = 250; x = -100; y = -100; amount = 3; type = 3; shooting = {rate = 20}};
        {time = 250; x = 100;  y = -100; amount = 3; type = 3; shooting = {rate = 20}};

        {time = 450; x = 100;  y = 100;  amount = 6; type = 0; startRandCount = 49; shooting = {rate = 30}};
        {time = 450; x = -100; y = 100;  amount = 6; type = 0; startRandCount = 49; shooting = {rate = 30}};
        {time = 450; x = .5;   y = .5;   amount = 6; type = 0; startRandCount = 49; shooting = {rate = 30}};
        {time = 450; x = -100; y = -100; amount = 6; type = 0; startRandCount = 49; shooting = {rate = 30}};
        {time = 450; x = 100;  y = -100; amount = 6; type = 0; startRandCount = 49; shooting = {rate = 30}};
    };
    items = {
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    -- friendlyFire = true;     --Optional
    minLevelLength = 600;
    stickOffset = 3;
    buttonOffset = 1;
    -- pinballMode =false;     --Optional
};
{   -- 7)  Introduce shield, boost
    levelMessage = "Bring it.";
    enemies = {
        {time=60; x=.5; y=.5; type=0; amount = 5; randomRate = 30; randomThrust = 20000; randomAddition = 1; linearDamping = 0};
--      {time = 60; x = 500; y = 700; type = 0; health = 200; shooting = {type = 1; clipSize = 10; rate = 40; angleSeperation = .05; number = 3}};
        {time = 100; x = 100;  y = 100;  amount = 3; type = 0; shooting = {}};
        {time = 100; x = -100; y = 100;  amount = 3; type = 0; shooting = {}};
        {time = 100; x = .5;   y = .5;   amount = 3; type = 0; shooting = {}};
        {time = 100; x = -100; y = -100; amount = 3; type = 0; shooting = {}};
        {time = 100; x = 100;  y = -100; amount = 3; type = 0; shooting = {}};

        {time = 100; x = 100;  y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = -100; y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = .5;   y = .5;   amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = -100; y = -100; amount = 3; type = 3; shooting = {rate = 20}};
        {time = 100; x = 100;  y = -100; amount = 3; type = 3; shooting = {rate = 20}};

        {time = 140; x = .05;  y = .05;  amount = 3; type = 1; shooting = {rate = 40}};
        {time = 140; x = -.05; y = .05;  amount = 3; type = 0; shooting = {rate = 40}};
        {time = 140; x = .5;   y = .5;   amount = 3; type = 1; shooting = {rate = 40}};
        {time = 140; x = -.05; y = -.05; amount = 3; type = 0; shooting = {rate = 40}};
        {time = 140; x = .05;  y = -.05; amount = 3; type = 1; shooting = {rate = 40}};

        {time = 140; x = -.35; y = -.15; amount = 3; type = 1; shooting = {rate = 40}};
        {time = 140; x = .25;  y = -.65; amount = 3; type = 0; shooting = {rate = 40}};
        {time = 140; x = -.55; y = -.95; amount = 3; type = 1; shooting = {rate = 40}};
        {time = 140; x = .35;  y = -.65; amount = 3; type = 0; shooting = {rate = 40}};

        {time = 250; x = 100;  y = 100;  amount = 1; type = 3; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = -100; y = 100;  amount = 1; type = 2; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = .5;   y = .5;   amount = 1; type = 2; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = -100; y = -100; amount = 1; type = 2; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = 100;  y = -100; amount = 1; type = 3; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};

        {time = 450; x = 100;  y = 100;  amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = -100; y = 100;  amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = .5;   y = .5;   amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = -100; y = -100; amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = 100;  y = -100; amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
    };
    items = {
        {time = 0; x = .5; y = .5; button = "X"; boost = {speed = 7000}};
        {time = 50; x = .05; y = .5; button = "X"; shield = {duration = 7000; health = 100; cooldown = 500}};
        {time = 50; x = -.05; y = .5; button = "X"; shield = {duration = 100; health = 500; cooldown = 300;}};
        {time = 100; x = .5; y = .5; button = "X"; shooting = {type = 1; rate = 100; radius = 5; speed = 100; linearDamping = 5}};
        {time = 100; x = .5; y = .5; button = "X"; shooting = {type = 1; rate = 100; radius = 3; speed = 100; linearDamping = 15}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    -- friendlyFire = true;     --Optional
    minLevelLength = 600;
    -- stickOffset = 2;
    -- buttonOffset = 4;
    -- pinballMode =false;     --Optional
};
{   -- 8)  All same color
    levelMessage = "Now in 1 bit color!";
    enemies = {
        {time=60; x=.5; y=.5; type=0; amount = 5; randomRate = 30; randomThrust = 20000; randomAddition = 1; linearDamping = 0};
--      {time = 60; x = 500; y = 700; type = 0; health = 200; shooting = {type = 1; clipSize = 10; rate = 40; angleSeperation = .05; number = 3}};
        {time = 70; x = .05;  y = .05;  amount = 1; type = 1;};
        {time = 70; x = -.05; y = .05;  amount = 1; type = 1;};
        {time = 70; x = .5;   y = .5;   amount = 1; type = 1;};
        {time = 70; x = -.05; y = -.05; amount = 1; type = 1;};
        {time = 70; x = .05;  y = -.05; amount = 1; type = 1;};
        {time = 85; x = .05;  y = .05;  amount = 1; type = 1;};
        {time = 85; x = -.05; y = .05;  amount = 1; type = 1;};
        {time = 85; x = .5;   y = .5;   amount = 1; type = 1;};
        {time = 85; x = -.05; y = -.05; amount = 1; type = 1;};
        {time = 85; x = .05;  y = -.05; amount = 1; type = 1;};

        {time = 120; x = 100;  y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 120; x = -100; y = 100;  amount = 3; type = 3; shooting = {rate = 20}};
        {time = 120; x = .5;   y = .5;   amount = 3; type = 3; shooting = {rate = 20}};
        {time = 120; x = -100; y = -100; amount = 3; type = 3; shooting = {rate = 20}};
        {time = 120; x = 100;  y = -100; amount = 3; type = 3; shooting = {rate = 20}};

        {time = 190; x = .05;  y = .05;  amount = 3; type = 1; shooting = {rate = 40}};
        {time = 190; x = -.05; y = .05;  amount = 3; type = 0; shooting = {rate = 40}};
        {time = 190; x = .5;   y = .5;   amount = 3; type = 1; shooting = {rate = 40}};
        {time = 190; x = -.05; y = -.05; amount = 3; type = 0; shooting = {rate = 40}};
        {time = 190; x = .05;  y = -.05; amount = 3; type = 1; shooting = {rate = 40}};

        {time = 190; x = -.35; y = -.15; amount = 3; type = 1; shooting = {rate = 40}};
        {time = 190; x = .25;  y = -.65; amount = 3; type = 0; shooting = {rate = 40}};
        {time = 190; x = -.55; y = -.95; amount = 3; type = 1; shooting = {rate = 40}};
        {time = 190; x = .35;  y = -.65; amount = 3; type = 0; shooting = {rate = 40}};

        {time = 250; x = 100;  y = 100;  amount = 1; type = 3; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = -100; y = 100;  amount = 1; type = 2; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = .5;   y = .5;   amount = 1; type = 2; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = -100; y = -100; amount = 1; type = 2; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};
        {time = 250; x = 100;  y = -100; amount = 1; type = 3; shooting = {lastFire = 300; rate = 100; mass = 10; number = 30; angleSeperation = math.pi/15; speed = 100000}};

        {time = 450; x = 100;  y = 100;  amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = -100; y = 100;  amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = .5;   y = .5;   amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = -100; y = -100; amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
        {time = 450; x = 100;  y = -100; amount = 5; type = 0; startRandCount = 25; shooting = {rate = 30}};
    };
    items = {
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    -- friendlyFire = true;     --Optional
    minLevelLength = 600;
    -- stickOffset = 2;
    -- buttonOffset = 4;
    allColor = {255, 255, 255, 255};
    -- pinballMode =false;     --Optional
};
{
    levelMessage = "You can't get out if I trap you.";
    enemies = {
        {time = 100; x = -.05; y = .05; type = 1; width = 35; height = 35; speed = 0; health = 300; shooting = {rate = 20; mass = 10; number = 50; angleSeperation = math.pi/25; speed = 100000};};-- shield = {duration = 1000; cooldown = 200; health = 400;}};
        {time = 100; x = -.05; y = -.05; type = 1; width = 35; height = 35; speed = 0; health = 300; shooting = {rate = 20; mass = 10; number = 50; angleSeperation = math.pi/25; speed = 100000};};-- shield = {duration = 1000; cooldown = 200; health = 400;}};
        {time = 100; x = .05; y = -.05; type = 1; width = 35; height = 35; speed = 0; health = 300; shooting = {rate = 20; mass = 10; number = 50; angleSeperation = math.pi/25; speed = 100000};};-- shield = {duration = 1000; cooldown = 200; health = 400;}};
        {time = 100; x = .05; y = .05; type = 1; width = 35; height = 35; speed = 0; health = 300; shooting = {rate = 20; mass = 10; number = 50; angleSeperation = math.pi/25; speed = 100000};};-- shield = {duration = 1000; cooldown = 200; health = 400;}};
        {time = 300; x = -100; y = -100; amount = 5; type = 1};
        {time = 300; x = 100; y = -100; amount = 5; type = 1};
        {time = 300; x = 100; y = 100; amount = 5; type = 1};
        {time = 300; x = -100; y = -100; amount = 5; type = 1};
        {time = 450; x = -100; y = -100; amount = 5; type = 0};
        {time = 450; x = 100; y = -100; amount = 5; type = 0};
        {time = 450; x = 100; y = 100; amount = 5; type = 0};
        {time = 450; x = -100; y = -100; amount = 5; type = 0};
        {time = 450; x = -100; y = -100; amount = 5; type = 3; approach = 200};
        {time = 450; x = 100; y = -100; amount = 5; type = 3; approach = 200};
        {time = 450; x = 100; y = 100; amount = 5; type = 3; approach = 200};
        {time = 450; x = -100; y = -100; amount = 5; type = 3; approach = 200};
    };
    walls = {
        {time = 0; x = .15; y = .15; doHide = false; destroyTime = 600; type = "static"; friendlyTransparent = true; pairs = {{x = 0, y = 0}, {x = .7, y = 0}}};
        {time = 0; x = .85; y = .15; doHide = false; destroyTime = 600; type = "static"; friendlyTransparent = true; pairs = {{x = 0, y = 0}, {x = 0, y = .7}}};
        {time = 0; x = .15; y = .15; doHide = false; destroyTime = 600; type = "static"; friendlyTransparent = true; pairs = {{x = 0, y = 0}, {x = 0, y = .7}}};
        {time = 0; x = .15; y = .85; doHide = false; destroyTime = 600; type = "static"; friendlyTransparent = true; pairs = {{x = 0, y = 0}, {x = .7, y = 0}}};
    };
    items = {
        -- {time = 100; x = .5; y = .5; button = "B"; shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180}};
        -- {time = 100; x = .5; y = .5; button = "Y"; boost = {speed = 7000}};
        -- {time = 100; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        -- {time = 100; x = .5; y = .5; button = "B"; shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180}};
        -- {time = 100; x = .5; y = .5; button = "Y"; boost = {speed = 7000}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    friendlyFire = false;   --Optional
    minLevelLength = 600;
    -- pinballMode =false;     --Optional
};
{
    levelMessage = "Oops. Ok, these walls will work.";
    enemies = {
        {time = 100; x = -100; y = 100; amount = 0; type = 1; width = 150; height = 150; speed = 1000; spawnOnDead = {
            {time = 100; x = -100; y = 100; amount = 15; type = 1; width = 10; height = 10; speed = 100};
        }};
        {time = 100; x = 100; y = -100; amount = 0; type = 1; width = 150; height = 150; speed = 1000; spawnOnDead = {
            {time = 100; x = 100; y = -100; amount = 15; type = 1; width = 10; height = 10; speed = 100};
        }};
        {time = 100; x = 100; y = 100; amount = 0; type = 1; width = 150; height = 150; speed = 1000; spawnOnDead = {
            {time = 100; x = 100; y = 100; amount = 15; type = 1; width = 10; height = 10; speed = 100};
        }};
        {time = 100; x = -100; y = -100; amount = 0; type = 1; width = 150; height = 150; speed = 1000; spawnOnDead = {
            {time = 100; x = -100; y = -100; amount = 15; type = 1; width = 10; height = 10; speed = 100};
        }};
        {time = 300; x = -100; y = -100; amount = 3; type = 1; shooting = {}};
        {time = 300; x = 100; y = -100; amount = 3; type = 1; shooting = {}};
        {time = 300; x = 100; y = 100; amount = 3; type = 1; shooting = {}};
        {time = 300; x = -100; y = -100; amount = 3; type = 1; shooting = {}};
        {time = 450; x = -100; y = -100; amount = 3; type = 0};
        {time = 450; x = 100; y = -100; amount = 3; type = 0};
        {time = 450; x = 100; y = 100; amount = 3; type = 0};
        {time = 450; x = -100; y = -100; amount = 3; type = 0};
        {time = 450; x = -100; y = -100; amount = 3; type = 3; approach = 200};
        {time = 450; x = 100; y = -100; amount = 3; type = 3; approach = 200};
        {time = 450; x = 100; y = 100; amount = 3; type = 3; approach = 200};
        {time = 450; x = -100; y = -100; amount = 3; type = 3; approach = 200};
    };
    walls = {
        {time = 0; x = .15; y = .15; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = .7, y = 0}}};
        {time = 0; x = .85; y = .15; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .3}}};
        {time = 0; x = .85; y = .45; doHide = false; enemyBulletTransparent = true; movingTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .1}}};
        {time = 0; x = .85; y = .55; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .3}}};
        {time = 0; x = .15; y = .15; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .7}}};
        {time = 0; x = .15; y = .85; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = .7, y = 0}}};
    };
    items = {
        -- {time = 100; x = .5; y = .5; button = "B"; shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180}};
        -- {time = 100; x = .5; y = .5; button = "Y"; boost = {speed = 7000}};
        -- {time = 100; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        -- {time = 100; x = .5; y = .5; button = "B"; shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180}};
        -- {time = 100; x = .5; y = .5; button = "Y"; boost = {speed = 7000}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    friendlyFire = false;   --Optional
    minLevelLength = 600;
    -- pinballMode =false;     --Optional
};
{
    levelMessage = "Less control. That'll fix things.";
    enemies = {
        {time = 100; x = -100; y = -100; amount = 15; type = 1;};
        {time = 100; x = 100; y = -100; amount = 15; type = 1;};
        {time = 100; x = 100; y = 100; amount = 15; type = 1;};
        {time = 100; x = -100; y = -100; amount = 15; type = 1;};
        {time = 300; x = -100; y = -100; amount = 5; type = 1; shooting = {}};
        {time = 300; x = 100; y = -100; amount = 5; type = 1; shooting = {}};
        {time = 300; x = 100; y = 100; amount = 5; type = 1; shooting = {}};
        {time = 300; x = -100; y = -100; amount = 5; type = 1; shooting = {}};
        {time = 450; x = -100; y = -100; amount = 5; type = 0};
        {time = 450; x = 100; y = -100; amount = 5; type = 0};
        {time = 450; x = 100; y = 100; amount = 5; type = 0};
        {time = 450; x = -100; y = -100; amount = 5; type = 0};
        {time = 450; x = -100; y = -100; amount = 5; type = 3; approach = 200};
        {time = 450; x = 100; y = -100; amount = 5; type = 3; approach = 200};
        {time = 450; x = 100; y = 100; amount = 5; type = 3; approach = 200};
        {time = 450; x = -100; y = -100; amount = 5; type = 3; approach = 200};
    };
    walls = {
        {time = 0; x = .2; y = .1; doHide = false; enemyBulletTransparent = true; destroyTime = 300; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};
        {time = 0; x = .4; y = .0; doHide = false; enemyBulletTransparent = true; destroyTime = 320; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};
        {time = 0; x = .6; y = .1; doHide = false; enemyBulletTransparent = true; destroyTime = 350; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};
        {time = 0; x = .8; y = .0; doHide = false; enemyBulletTransparent = true; destroyTime = 280; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};

        {time = 200; x = .0; y = .2; doHide = false; enemyBulletTransparent = true; destroyTime = 500; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};
        {time = 280; x = .1; y = .4; doHide = false; enemyBulletTransparent = true; destroyTime = 520; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};
        {time = 220; x = .0; y = .6; doHide = false; enemyBulletTransparent = true; destroyTime = 550; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};
        {time = 240; x = .1; y = .8; doHide = false; enemyBulletTransparent = true; destroyTime = 480; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};

        {time = 400; x = .1; y = .2; doHide = false; enemyBulletTransparent = true; destroyTime = 800; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.3, y = .8}}};
        {time = 480; x = .3; y = .4; doHide = false; enemyBulletTransparent = true; destroyTime = 820; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.2, y = .5}}};
        {time = 420; x = .2; y = .3; doHide = false; enemyBulletTransparent = true; destroyTime = 850; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.5, y = .5}}};
        {time = 440; x = .1; y = .2; doHide = false; enemyBulletTransparent = true; destroyTime = 780; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.4, y = .1}}};

        {time = 900; x = .2; y = .1; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};
        {time = 900; x = .4; y = .0; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};
        {time = 900; x = .6; y = .1; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};
        {time = 900; x = .8; y = .0; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .9}}};

        {time = 900; x = .0; y = .2; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};
        {time = 900; x = .1; y = .4; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};
        {time = 900; x = .0; y = .6; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};
        {time = 900; x = .1; y = .8; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.9, y = .0}}};

        {time = 900; x = .1; y = .2; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.3, y = .8}}};
        {time = 900; x = .3; y = .4; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0.5}, {x = 0.2, y = 0}}};
        {time = 900; x = .2; y = .3; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0.7, y = 0}, {x = 0.0, y = .5}}};
        {time = 900; x = .1; y = .2; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.4, y = .1}}};
        {time = 900; x = .3; y = .4; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0.4, y = 0}, {x = 0.0, y = 0.2}}};
        {time = 900; x = .2; y = .3; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0.3}, {x = 0.5, y = 0}}};
        {time = 900; x = .1; y = .2; doHide = false; enemyBulletTransparent = true; destroyTime = 100000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0.4, y = .1}}};

        -- {time = 0; x = .0; y = .45; doHide = false; enemyBulletTransparent = true; movingTransparent = true; destroyTime = 300; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .1}}};
        -- {time = 0; x = .85; y = .0; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .3}}};
        -- {time = 0; x = .15; y = .15; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = 0, y = .7}}};
        -- {time = 0; x = .15; y = .85; doHide = false; enemyBulletTransparent = true; destroyTime = 1000; type = "static"; pairs = {{x = 0, y = 0}, {x = .7, y = 0}}};
    };
    items = {
        -- {time = 100; x = .5; y = .5; button = "B"; shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180}};
        -- {time = 100; x = .5; y = .5; button = "Y"; boost = {speed = 7000}};
        -- {time = 100; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        -- {time = 100; x = .5; y = .5; button = "B"; shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180}};
        -- {time = 100; x = .5; y = .5; button = "Y"; boost = {speed = 7000}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    friendlyFire = false;   --Optional
    minLevelLength = 600;
    pinballMode = true;     --Optional
};
{
    levelMessage = "Fine, I'll send my best.";
    enemies = {
        {time = 300; x = -100; y = 100; amount = 5; type = 1; shooting = {}; shootingIfShot = {}};
        {time = 300; x = 100; y = -100; amount = 5; type = 1; shooting = {}; shootingIfShot = {}};
        {time = 300; x = 100; y = 100; amount = 5; type = 1; shooting = {}; shootingIfShot = {}};
        {time = 300; x = -100; y = -100; amount = 5; type = 1; shooting = {}; shootingIfShot = {}};
        {time = 200; x = -100; y = 100; amount = 2; type = 4; style = "fill"; shooting = {rate = 60}};
        {time = 200; x = 100; y = -100; amount = 2; type = 4; style = "fill"; shooting = {rate = 60}};
        {time = 200; x = 100; y = 100; amount = 2; type = 4; style = "fill"; shooting = {rate = 60}};
        {time = 200; x = -100; y = -100; amount = 2; type = 4; style = "fill"; shooting = {rate = 60}};
        {time = 450; x = -100; y = 100; amount = 5; type = 0};
        {time = 450; x = 100; y = -100; amount = 5; type = 0};
        {time = 450; x = 100; y = 100; amount = 5; type = 0};
        {time = 450; x = -100; y = -100; amount = 5; type = 0};
        {time = 450; x = -100; y = 100; amount = 5; type = 3; approach = 200};
        {time = 450; x = 100; y = -100; amount = 5; type = 3; approach = 200};
        {time = 450; x = 100; y = 100; amount = 5; type = 3; approach = 200};
        {time = 450; x = -100; y = -100; amount = 5; type = 3; approach = 200};
        {time = 650; x = .5; y = .5; amount = 0; type = 4; isBoss = 1; health = 1500; style = "fill"; width = 80; height = 80; speed = 24000; timeInRun = 150; timeInSafe = 200;  bulletAversion = 4000; runMultiplier = 3; torqueMult = 10; shooting = {rate = 10; radius = 20; damage = 100}; spawnOnDead = {
            {x = 0; y = 0; amount = 15; type = 4; style = "fill";  width = 20; height = 20; speed = 100; torqueMult = .04};
        }};

        {time = 900; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};
        {time = 1200; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};
        {time = 1500; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};
        {time = 1800; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};
        {time = 2100; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};
        {time = 2400; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};
        {time = 2700; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};
        {time = 3000; x = -100; y = -100; amount = 5; type = 3; approach = 200; bossSpawn = 1};

    };
    walls = {
    };
    audio = {{time = 500; source = "ironman"}};
    items = {
        -- {time = 0; x = .5; y = .5; button = "R"; shooting = {type = 1; rate = 100; radius = 5; speed = 100;}};
        -- {time = 0; x = .5; y = .5; button = "R"; shooting = {type = 1; rate = 100; radius = 3; speed = 100;}};
        -- {time = 0; x = .5; y = .5; button = "R"; shooting = {type = 2; rate = 30; radius = 1; speed = 100;}};
        -- {time = 0; x = .5; y = .5; button = "R"; shooting = {type = 1; rate = 100; radius = 10; speed = 100;}};
        -- {time = 0; x = .5; y = .5; button = "R"; shooting = {type = 1; rate = 100; radius = 5; speed = 100;}};

        {time = 0; x = .5; y = .5; button = "R"; upgrade = 2; shooting = {type = 1; rate = 100; radius = 5; speed = 100;}};
        {time = 0; x = .5; y = .5; button = "R"; upgrade = 2; shooting = {type = 1; rate = 100; radius = 3; speed = 100;}};
        {time = 0; x = .5; y = .5; button = "R"; upgrade = 2; shooting = {type = 2; rate = 30; radius = 1; speed = 100;}};
        {time = 0; x = .5; y = .5; button = "R"; upgrade = 2; shooting = {type = 1; rate = 100; radius = 10; speed = 100;}};
        {time = 0; x = .5; y = .5; button = "R"; upgrade = 2; shooting = {type = 1; rate = 100; radius = 5; speed = 100;}};
    };
    minAlive = 1;           --Optional
    -- firingAngle = math.pi;   --Optional
    friendlyFire = false;   --Optional
    minLevelLength = 1000;
    -- pinballMode = true;     --Optional
};
}

LevelsInfo.winTopMessage = "You won!"
LevelsInfo.winBottomMessage = "The answer: YAYYYYYYYYYyYYYyY"

LevelsInfo.shipColors = {{0, 0, 255, 255}, {0, 255, 0, 255}, {255, 0, 0, 255}, {0, 255, 255, 255}, {255, 255, 0, 255}}
LevelsInfo.enemyColors = {{255, 255, 0, 255}, {255, 0, 0, 255}, {0, 255, 0, 255}, {0, 255, 255, 255}, {128, 128, 0, 255}, {255, 255, 255, 255}}

LevelsInfo.dropItems = {
        {keyboard = "j"; time = 220; x = .5; y = .5; button = "R"; upgrade = 4; shooting = {radial = true ; type = 1; rate = 1; number = 3}};
        {keyboard = "k"; time = 220; x = .5; y = .5; button = "Y"; upgrade = 4; shooting = {rate = 25; mass = 10000; number = 360; angleSeperation = math.pi/180; }};
        {keyboard = "l"; time = 220; x = .5; y = .5; button = "R"; upgrade = 3; shooting = {radial = true ; type = 1; rate = 3; number = 3}};
        {keyboard = "e"; time = 450; x = .45; y = .5; button = "A"; shooting = {rate = 6}};
        {keyboard = "r"; time = 220; x = .5; y = .5; button = "R"; shooting = {radial = true ; type = 1; rate = 5}};
        {keyboard = "t"; time = 140; x = .15;  y = .5; button = "B"; frozen = {}};
        {keyboard = "y"; time = 220; x = .5; y = -.05;   button = "Y";  shooting = {rate = 1000; mass = 10000; number = 360; angleSeperation = math.pi/180; }};--audio = "bigBoom"}};
        {keyboard = "u"; time = 200; x = .5; y = .5;  upgrade = 1; button = "R"; shooting = {rate = 3}};
        {keyboard = "i"; time = 0; x = .5; y = .5; button = "X"; boost = {speed = 7000}};
        {keyboard = "o"; time = 100; x = .5; y = .5; button = "X"; shooting = {type = 1; rate = 100; radius = 3; speed = 100; linearDamping = 15}};
        };

LevelsInfo.resetEntry = function (thing)
    thing.isActivated = false
    thing.isEntryAnimated = false
    if (math.abs(thing.x) < 1) then
        thing.x = thing.x * SCREEN_WIDTH
    end
    if (math.abs(thing.y) < 1) then
        thing.y = thing.y * (SCREEN_HEIGHT - BordersLib.BottomBar)
    end
    if (thing.x < 0) then
        thing.x = thing.x + SCREEN_WIDTH
    end
    if (thing.y < 0) then
        thing.y = thing.y + (SCREEN_HEIGHT - BordersLib.BottomBar)
    end
end

LevelsInfo.resetEnemiesList = function (listIn, listToAddTo)
    for k,enemy in ipairs(listIn) do
        LevelsInfo.resetEntry(enemy)
        if enemy.spawnOnDead then
            LevelsInfo.resetEnemiesList(enemy.spawnOnDead, enemy.spawnOnDead)
        end
        if (enemy.amount) then
            print(enemy.amount)
            for z=1,enemy.amount do
                e = Tools.clone(enemy)
                e.amount = nil
                table.insert(listToAddTo, e)
            end
            enemy.amount = nil
        end
    end
end

LevelsInfo.resetLevelsProgress = function ()
    for i,Level in pairs(LevelsInfo.l) do
        LevelsInfo.resetEnemiesList(LevelsInfo.l[i].enemies, Level.enemies)
        for k, item in ipairs(LevelsInfo.l[i].items) do
            LevelsInfo.resetEntry(item)
        end
        if (LevelsInfo.l[i].walls) then
            for k,wall in ipairs(LevelsInfo.l[i].walls) do
                LevelsInfo.resetEntry(wall)
                for j,pair in ipairs(wall.pairs) do
                    LevelsInfo.resetEntry(pair)
                end
            end
        end
    end
    for i, item in ipairs(LevelsInfo.dropItems) do
        LevelsInfo.resetEntry(item)
    end
end


return LevelsInfo
