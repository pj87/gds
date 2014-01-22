local angle = 0 
local num_asteroids = 10 
local asteroids_moving = false 

function create_asteroid(x, y, magnitude, size, speed, angle) 
	asteroid = {} 
	--asteroid.body = love.physics.newBody(world, math.random(500), math.random(500), "dynamic") 
	asteroid.body = love.physics.newBody(world, x, y, "dynamic") 
	asteroid.magnitude = magnitude 
	asteroid.size = size 
	asteroid.speed = speed --50 + math.random(200) 
	asteroid.angle = angle --math.random(6.283) 
	asteroid.body:applyForce(speed * math.cos(angle), speed * math.sin(angle)) 
	return asteroid 
end 

function create_enemy(x, y, magnitude, size_x, size_y, speed, angle) 
	enemy = {} 
	enemy.shots = {} 
	--enemy.body = love.physics.newBody(world, x, y, "dynamic") 
	enemy.x = x 
	enemy.y = y 
	enemy.magnitude = magnitude 
	enemy.size_x = size_x 
	enemy.size_y = size_y 
	enemy.speed = speed --50 + math.random(200) 
	enemy.angle = angle --math.random(6.283) 
	--enemy.body:applyForce(speed * math.cos(angle), speed * math.sin(angle)) 
	return enemy 
end 

function enemy_shoot() 
	if (math.random(100) <= 1) then 
		shot = {} 
		shot.x = objects.enemy.x 
		shot.y = objects.enemy.y 
		shot.active = true 
		shot.speed = math.random(2.5) 
		shot.angle = math.random(6.283) 
		table.insert(objects.enemy.shots, shot) 
	end 
end 

function update_enemy_shots() 
	for index, shot in ipairs(objects.enemy.shots) do 
		shot.x = shot.x + shot.speed * math.sin(shot.angle) 
		shot.y = shot.y + shot.speed * -math.cos(shot.angle) 
	end 
end 

function divide_asteroids_after_collision(remAsteroid, remShot) 
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
				else 
					table.insert(remAsteroid, i) 
				end 		
			end 
		end 
	end 
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
	
	objects.enemy = {} 
	objects.enemy = create_enemy(math.random(500), math.random(500), 1, 45, 18, 20, math.random(6.283)) 
	--table.insert(objects.enemy, enemy) 
	
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
	enemy_img = love.graphics.newImage("enemy.png") 
	
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

function check_all_outside_screen() 
	
	for index, asteroid in ipairs(objects.asteroids) do 
		if (asteroid.body:getX() < 0) then 
			asteroid.body:setX(800) 
		end 
	
		if (asteroid.body:getY() < 0) then 
			asteroid.body:setY(600) 
		end 
	
		if (asteroid.body:getX() > 800) then 
			asteroid.body:setX(0) 
		end 
	
		if (asteroid.body:getY() > 600) then 
			asteroid.body:setY(0) 
		end 
	end 
	
	if (objects.player.body:getX() < 0) then 
		objects.player.body:setX(800) 
	end 
	
	if (objects.player.body:getY() < 0) then 
		objects.player.body:setY(600) 
	end 
	
	if (objects.player.body:getX() > 800) then 
		objects.player.body:setX(0) 
	end 
	
	if (objects.player.body:getY() > 600) then 
		objects.player.body:setY(0) 
	end 
end 
	
function love.update(dt)
    world:update(dt)
	
	check_all_outside_screen() 
	
    --here we are going to create some keyboard events
    if love.keyboard.isDown("right") then --press the right arrow key to push the player to the right
	   angle = angle + dt * math.pi/2
    elseif love.keyboard.isDown("left") then --press the left arrow key to push the player to the left
	   angle = angle - dt * math.pi/2
    elseif love.keyboard.isDown("up") then --press the up arrow key to set the player in the air
       objects.player.body:applyForce(50 * math.sin(angle), -50 * math.cos(angle))
	end

	if (asteroids_moving == false) then 
		for index, asteroid in ipairs(objects.asteroids) do 
			asteroid.body:applyForce(50 * math.sin(angle), -50 * math.cos(angle))
		end 
		asteroids_moving = true 
	end 
	
	angle = angle % (2*math.pi) 

	local remEnemy = {} 
    local remShot = {} 
	local remAsteroid = {} 
	
	divide_asteroids_after_collision(remAsteroid, remShot) 

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

	objects.enemy.x = objects.enemy.x + objects.enemy.speed * math.sin(objects.enemy.angle) * dt 
	objects.enemy.y = objects.enemy.y + objects.enemy.speed * -math.cos(objects.enemy.angle) * dt 
	
	if(math.random(1000) <= 1) then 
		objects.enemy.angle = math.random(6.283) 
	end 
	
	enemy_shoot() 
	update_enemy_shots() 
	
    -- remove the marked enemies
    for i,v in ipairs(remEnemy) do
        table.remove(enemies, v)
    end

    for i,v in ipairs(remShot) do
        table.remove(hero.shots, v)
    end

	for i,v in ipairs(remAsteroid) do
        table.remove(objects.asteroids, v)
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
	
	love.graphics.draw(enemy_img, objects.enemy.x, objects.enemy.y) 
	
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
	
	for i,v in ipairs(objects.enemy.shots) do 
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


