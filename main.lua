local angle = 0
local num_asteroids = 10 

function create_asteroid(x, y, magnitude, size, speed, angle) 
	asteroid = {} 
	--asteroid.body = love.physics.newBody(world, math.random(500), math.random(500), "dynamic") 
	asteroid.body = love.physics.newBody(world, x, y, "dynamic") 
	asteroid.magnitude = magnitude 
	asteroid.size = size 
	asteroid.speed = speed --50 + math.random(200) 
	asteroid.angle = angle --math.random(6.283) 
	return asteroid 
end 
	
function love.load()
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81    

    objects = {} -- table to hold all our physical objects 

    --let's create a player
    objects.player = {}
    objects.player.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	--objects.player.shape = love.physics.newCircleShape(20) --the player's shape has a radius of 20
    --objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1) -- Attach fixture to body and give it a density of 1.
    --objects.player.fixture:setRestitution(0.9) --let the player bounce
	
	--objects.enemies = {}
    --objects.enemy1.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") 
	
	--family = {}
    --family[1]={}
    --family[1].mother="Angie"
    --family[1].father="Michael"
    --family[1].children={}
    --family[1].children[1]="Jessica"
    --family[1].children[2]="Thomas"
	
	--objects.asteroid = {} 
	--objects.asteroid.body = {}
	--objects.asteroid.size = {} -- There are three sizes of asteroids (big, medim, small) 
	
	--objects.asteroid.body = love.physics.newBody(world, 400, 400, "dynamic") 
	--objects.asteroid.body:applyForce(100, 100) 
	--b = love.physics.newBody(world, math.random(600), math.random(600), "dynamic") 
	--b:applyForce(100, 100) 
	--objects.asteroid.body = b 
	
	--table.insert(objects.asteroid.bodies, love.physics.newBody(world, math.random(200), math.random(200)))
	
	objects.asteroids = {} 
	
	for i = 1, num_asteroids do  
		asteroid = create_asteroid(math.random(500), math.random(500), 3, 60, 50, math.random(6.283)) 
		table.insert(objects.asteroids, asteroid) 
    end 
	
	--for j = 1, 10 do 
	--	objects.asteroids[j].size = 2 
    --end 
	
    --for i=1, 10 do 
    --  objects.asteroids[i].body = love.physics.newBody(world, math.random(200), math.random(200)) --place the body in the center of the world and make it dynamic, so it can move around
    --end 

    bg = love.graphics.newImage("bg.png") 
	statek = love.graphics.newImage("statek.png") 
	pocisk = love.graphics.newImage("pocisk.png") 
	duza_asteroida = love.graphics.newImage("duza_asteroida.png") 
	srednia_asteroida = love.graphics.newImage("srednia_asteroida.png") 
	mala_asteroida = love.graphics.newImage("mala_asteroida.png") 
	
    hero = {} -- new table for the hero 
    hero.x = 300    -- x,y coordinates of the hero 
    hero.y = 450 
    hero.width = 30 
    hero.height = 15 
    hero.speed = 150 
    hero.shots = {} -- holds our fired shots 

    enemies = {}

    for i=0,7 do 
        enemy = {} 
        enemy.width = 40 
        enemy.height = 20 
        enemy.x = i * (enemy.width + 60) + 100 
        enemy.y = enemy.height + 100 
        table.insert(enemies, enemy) 
    end

end

function love.keyreleased(key)
    if (key == " ") then
        shoot()
    end
end

function love.update(dt)
    world:update(dt)
	
    --here we are going to create some keyboard events
    if love.keyboard.isDown("right") then --press the right arrow key to push the player to the right
       --objects.player.body:applyForce(400, 0) 
	   angle = angle + dt * math.pi/2
	   --love.graphics.rotate(angle)
    elseif love.keyboard.isDown("left") then --press the left arrow key to push the player to the left
       --objects.player.body:applyForce(-400, 0)
	   angle = angle - dt * math.pi/2
    elseif love.keyboard.isDown("up") then --press the up arrow key to set the player in the air
       objects.player.body:applyForce(50 * math.sin(angle), -50 * math.cos(angle))
	elseif love.keyboard.isDown("down") then --press the up arrow key to set the player in the air
	   --objects.player.body:applyForce(math.rand(50) * math.sin(), 100) 
	   --objects.asteroid.body:applyForce(100, 100) 
	   --for i,v in ipairs(objects.asteroid.body) do 
			--objects.asteroids[i] = love.physics.newBody(world, math.random(200), math.random(200)) --place the body in the center of the world and make it dynamic, so it can move around 
			--love.graphics.draw(asteroida, v:getX(), v:getY()) 
			--v:applyForce(math.rand(50) * math.sin(v.angle), math.rand(50) * math.sin(v.angle))
			--objects.asteroid[i].size
		--end 
		
	for i = 1, num_asteroids do 
		angle = objects.asteroids[i].angle 
		speed = objects.asteroids[i].speed 
		objects.asteroids[i].body:applyForce(speed * math.cos(angle), speed * math.sin(angle)) 
	end 
       --objects.player.body:applyForce(math.cos(angle), 400)
end

	--objects.asteroid.body:applyForce(50 * math.sin(angle), -50 * math.cos(angle))
	
	angle = angle % (2*math.pi)
	
    -- keyboard actions for our hero
    --if love.keyboard.isDown("left") then
        --hero.x = hero.x - hero.speed*dt
    --elseif love.keyboard.isDown("right") then
        --hero.x = hero.x + hero.speed*dt
    --end

	local remEnemy = {}
    local remShot = {}
	
	-- collisions 
	for index, shot in ipairs(hero.shots) do 
		--for i = 1, num_asteroids do 
		for i, asteroid in ipairs(objects.asteroids) do 
			--if (shot.x > objects.asteroids[i].x and shot.y > objects.asteroids[i].y)
			--if (shot.active == true and CheckCollision(shot.x, shot.y, 10, 10, objects.asteroids[i].body:getX(), objects.asteroids[i].body:getY(), 50, 50) == true)  then
			size_asteroid = asteroid.size 
			size_shot = 10 
			if (shot.active == true and shot.x + size_shot >= asteroid.body:getX() and shot.x <= asteroid.body:getX() + size_asteroid 
			and shot.y + size_shot >= asteroid.body:getY() and shot.y <= asteroid.body:getY() + size_asteroid) then 
				table.insert(remShot, index) 
				--asteroid = create_asteroid() 
				shot.active = false 
				asteroid.magnitude = asteroid.magnitude - 1 
				local magnitude = asteroid.magnitude 
				local pos_x = asteroid.body:getX() 
				local pos_y = asteroid.body:getY() 
				
				if (magnitude == 2) then 
					asteroid.size = 40 
					asteroid_new = create_asteroid(pos_x + 20, pos_y + 20, 2, 40, 50, math.random(6.283)) 
					table.insert(objects.asteroids, asteroid_new) 
				elseif (magnitude == 1) then 
					asteroid.size = 25 
					asteroid_new = create_asteroid(pos_x + 12.5, pos_y + 12.5, 1, 25, 50, math.random(6.283)) 
					table.insert(objects.asteroids, asteroid_new) 
				end 
			end 
		end 
	end 

    -- update the shots
    for i,v in ipairs(hero.shots) do

        -- move them up up up
        v.x = v.x + v.dx * dt * 100 
		v.y = v.y + v.dy * dt * 100 

        -- mark shots that are not visible for removal
        if v.y < 0 then
            table.insert(remShot, i)
        end

        -- check for collision with enemies
        --for ii,vv in ipairs(enemies) do
            --if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then

                -- mark that enemy for removal
                --table.insert(remEnemy, ii)
                -- mark the shot to be removed
                --table.insert(remShot, i)

            --end
        --end

    end

    -- remove the marked enemies
    for i,v in ipairs(remEnemy) do
        table.remove(enemies, v)
    end

    for i,v in ipairs(remShot) do
        table.remove(hero.shots, v)
    end

    -- update those evil enemies
    for i,v in ipairs(enemies) do
        -- let them fall down slowly
        v.y = v.y + dt

        -- check for collision with ground
        if v.y > 465 then
            -- you lose!!!
        end

    end

end

function love.draw()
    -- let's draw a background
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg)

    -- let's draw some ground
    love.graphics.setColor(0,255,0,255)
    love.graphics.rectangle("fill", 0, 465, 800, 150)

    --love.graphics.setColor(193, 47, 14) --set the drawing color to red for the player
    --love.graphics.circle("fill", objects.player.body:getX(), objects.player.body:getY(), objects.player.shape:getRadius())

    -- let's draw our hero
	--love.graphics.rotate(angle)
    love.graphics.setColor(255,255,0,255)
    love.graphics.rectangle("fill", hero.x, hero.y, hero.width, hero.height)

	love.graphics.push() 
	--width = 48 
    --height = 57 
    --love.graphics.translate(width/2, height/2) 
    --love.graphics.translate(-75, -75)
	--love.graphics.rotate(angle) 
    --love.graphics.translate(hero.x, hero.y) 
	love.graphics.draw(statek, objects.player.body:getX(), objects.player.body:getY(), angle, 1, 1, 25, 25) 
	love.graphics.pop() 
	
	--love.graphics.draw(asteroida, objects.asteroid.body:getX(), objects.asteroid.body:getY()) 
	for index, asteroid in ipairs(objects.asteroids) do 
	--for i=1, num_asteroids do 
		--love.graphics.print(objects.asteroids[i].body:getX(), 100, 150); 		
			--love.graphics.print(i, 0, i * 30) 			
		if (asteroid.magnitude == 3) then 
			love.graphics.draw(duza_asteroida, asteroid.body:getX(), asteroid.body:getY()) 
		elseif (asteroid.magnitude == 2) then 
			love.graphics.draw(srednia_asteroida, asteroid.body:getX(), asteroid.body:getY()) 
		elseif (asteroid.magnitude == 1) then 
			love.graphics.draw(mala_asteroida, asteroid.body:getX(), asteroid.body:getY()) 
		end 
		
		love.graphics.print(asteroid.body:getX(), asteroid.body:getX() + 25, asteroid.body:getY() + 25) 
		love.graphics.print(asteroid.body:getY(), asteroid.body:getX() + 25, asteroid.body:getY() + 35) 
		
	end 
	--for i,v in ipairs(objects.asteroid.body) do 
      --objects.asteroids[i] = love.physics.newBody(world, math.random(200), math.random(200)) --place the body in the center of the world and make it dynamic, so it can move around 
	  --love.graphics.draw(duza_asteroida, v:getX(), v:getY()) 
    --end 
	
    -- let's draw our heros shots 
    love.graphics.setColor(255,255,255,255) 
    for i,v in ipairs(hero.shots) do 
        --love.graphics.rectangle("fill", v.x, v.y, 24, 29) 
		if (v.active == true) then 
			love.graphics.draw(pocisk, v.x, v.y) 
			love.graphics.print(v.x, v.x + 10, v.y) 
			love.graphics.print(v.y, v.x + 10, v.y + 10) 
		end 
    end
    -- let's draw our enemies 
    love.graphics.setColor(0,255,255,255) 
    for i,v in ipairs(enemies) do 
        love.graphics.rectangle("fill", v.x, v.y, v.width, v.height) 
    end 
	
	love.graphics.print(angle, 100, 100); 
end

function shoot()

    local shot = {}
    shot.x = objects.player.body:getX()+hero.width/2
    shot.y = objects.player.body:getY()
	shot.dx = math.sin(angle) 
	shot.dy = -math.cos(angle) 
	shot.active = true 
	
    table.insert(hero.shots, shot)

end

-- Collision detection function.
-- Checks if a and b overlap.
-- w and h mean width and height.
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
 
  --local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  --return ax1 > bx2 and ax2 > bx1 and ay1 > by2 and ay2 > by1
  if (ax1 + aw >= bx1 and ax1 <= bx1 + bw and ay1 + ah >= by1 and ay1 <= by1 + bh) then 
	return true 
  end 
  --return false 
end 


