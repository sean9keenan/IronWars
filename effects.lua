local EffectLib = {}

systems = {}
extraSystems = {}

EffectLib.init = function ()
	part1 = love.graphics.newImage("assets/img/part1.png");
	star = love.graphics.newImage("assets/img/star.png");
end

EffectLib.returnEffect = function(index, x, y)

	love.graphics.setColor(200, 200, 200);

	if (index == 0) then
		p = love.graphics.newParticleSystem(part1, 1000)
		p:setEmissionRate(1000)
		p:setSpeed(300, 400)
		p:setGravity(0)
		p:setSizes(.5, .1, .01)
		p:setColors(255, 255, 255, 255, 58, 128, 255, 0)
		if LevelsInfo.l[globalLevel].allColor then p:setColors(255,255,255,255,255,255,255,255) end
		p:setPosition(x, y)
		p:setLifetime(.1)
		p:setParticleLife(.3)
		p:setDirection(0)
		p:setSpread(math.pi*2)
		p:setRadialAcceleration(100)
		p:setTangentialAcceleration(-10)
		p:start()

		table.insert(extraSystems, p)
	elseif (index == 1) then
		p = love.graphics.newParticleSystem(part1, 100)
		p:setEmissionRate(200)
		p:setSpeed(300, 400)
		p:setGravity(0)
		p:setSizes(2, 1)
		p:setColors(255, 255, 255, 255, 58, 128, 255, 0)
		if LevelsInfo.l[globalLevel].allColor then p:setColors(255,255,255,255,255,255,255,255) end
		p:setPosition(x, y)
		p:setLifetime(.1)
		p:setParticleLife(.3)
		p:setDirection(0)
		p:setSpread(360)
		p:setRadialAcceleration(-2000)
		p:setTangentialAcceleration(1000)
		p:start()

		table.insert(extraSystems, p)
	elseif (index == 2 or index == 3) then
		p = love.graphics.newParticleSystem(part1, 100)
		p:setEmissionRate(100)
		p:setSpeed(400, 500)
		p:setGravity(0)
		p:setSizes(2, 1)
		p:setColors(255, 55, 55, 255, 255, 128, 128, 0)
		if (index == 3) then
			p:setColors(55, 55, 255, 255, 128, 128, 255, 0)
		end
		if LevelsInfo.l[globalLevel].allColor then p:setColors(255,255,255,255,255,255,255,255) end
		p:setPosition(x, y)
		p:setLifetime(1)
		p:setParticleLife(.3)
		p:setDirection(0)
		p:setSpread(360)
		p:setRadialAcceleration(-2000)
		p:setTangentialAcceleration(1000)
		p:start()

		table.insert(extraSystems, p)
	elseif (index == 4) then
		p = love.graphics.newParticleSystem(star, 100)
		p:setEmissionRate(100)
		p:setSpeed(400, 500)
		p:setGravity(0)
		p:setSizes(2, 1)
		p:setColors(255, 55, 55, 255, 255, 128, 128, 0)
		if (index == 5) then
			p:setColors(55, 55, 255, 255, 128, 128, 255, 0)
		end
		if LevelsInfo.l[globalLevel].allColor then p:setColors(255,255,255,255,255,255,255,255) end
		p:setPosition(x, y)
		p:setLifetime(1)
		p:setParticleLife(.7)
		p:setDirection(0)
		p:setSpread(360)
		p:setRadialAcceleration(-2000)
		p:setTangentialAcceleration(10)
		-- p:setRelativeRotation(true)
		p:start()

		table.insert(extraSystems, p)
	end
end

EffectLib.startEffect = function(index, x, y)
	p = EffectLib.returnEffect(index, x, y)
end

EffectLib.update = function(dt)
	for _, system in ipairs(extraSystems) do

		system:update(dt)
	end
end

EffectLib.draw = function()

	love.graphics.setColorMode("modulate")
	love.graphics.setBlendMode("additive")

	-- for _, system in ipairs(systems) do
	-- 	love.graphics.draw(system, 0, 0)
	-- end
	newExtraSystems = {}
	for _, system in ipairs(extraSystems) do
		love.graphics.draw(system, 0, 0)
		if (not system:isEmpty()) or system:isActive() then
			table.insert(newExtraSystems, system)
		else
			-- system.f:
		end
	end
	extraSystems = newExtraSystems;

end

return EffectLib
