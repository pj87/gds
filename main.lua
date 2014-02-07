local angle = 0 
local num_asteroids = 10 
local asteroids_moving = false 
local num_enemies = 5  
local game_state = 0 -- 0 - main menu, 1 - credits, 2 - game 

function create_asteroid(x, y, magnitude, size, speed, angle) 
	asteroid = {} 
	asteroid.body = love.physics.newBody(world, x, y, "dynamic") 
	asteroid.magnitude = magnitude 
	asteroid.size = size 
	asteroid.speed = speed 
	asteroid.angle = angle 
	return asteroid 
end 

function create_enemy(x, y, magnitude, size_x, size_y, speed, angle) 
	enemy = {} 
	enemy.shots = {} 
	enemy.x = x 
	enemy.y = y 
	enemy.magnitude = magnitude 
	enemy.size_x = size_x 
	enemy.size_y = size_y 
	enemy.speed = speed 
	enemy.angle = angle 
	enemy.alive = true 
	return enemy 
end 

function show_main_menu_screen() 
	love.graphics.print("New game", 650/2, 650/2 - 100) 
	love.graphics.print("Credits", 650/2, 650/2) 
	love.graphics.print("Exit", 650/2, 650/2 + 100) 
	
	--love.graphics.draw(mouse_pointer, love.mouse.getX() - mouse_pointer:getWidth() / 2, love.mouse.getY() - mouse_pointer:getHeight() / 2)
end 

function show_credits_screen() 
	love.graphics.print("Programming: Paweł Jastrzębski", 650/2, 650/2 - 200) 
	love.graphics.print("Game design: Radosław Smyk", 650/2, 650/2 - 100) 
	love.graphics.print("Graphics: Michał Król", 650/2, 650/2) 
	love.graphics.print("Music: ????", 650/2, 650/2 + 100) 
	love.graphics.print("Back", 650/2, 650/2 + 200) 
	
	--love.graphics.draw(mouse_pointer, love.mouse.getX() - mouse_pointer:getWidth() / 2, love.mouse.getY() - mouse_pointer:getHeight() / 2)
end 

function update_main_menu_screen() 
	
	if (love.mouse.isDown("l")) then 
		if (love.mouse.getX() > 650/2 and love.mouse.getX() < 650/2 + 100 and 
			love.mouse.getY() > 650/2 - 100 and love.mouse.getY() < 650/2) then 
				game_state = 2 
		elseif (love.mouse.getX() > 650/2 and love.mouse.getX() < 650/2 + 100 and 
				love.mouse.getY() >= 650/2 and love.mouse.getY() < 650/2 + 100) then 
				game_state = 1 
		elseif (love.mouse.getX() > 650/2 and love.mouse.getX() < 650/2 + 100 and 
				love.mouse.getY() >= 650/2 + 100 and love.mouse.getY() < 650/2 + 200) then 
				love.event.quit() 
		end 
	end 
end 

function update_credits_screen() 
	
	if (love.mouse.isDown("l") and love.mouse.getX() > 650/2 and love.mouse.getX() < 650/2 + 100 and 
		love.mouse.getY() > 650/2 + 200 and love.mouse.getY() < 650/2 + 300) then 
			game_state = 0 
	end 
	--love.graphics.draw(mouse_pointer, love.mouse.getX() - mouse_pointer:getWidth() / 2, love.mouse.getY() - mouse_pointer:getHeight() / 2)
end 

function enemies_shoot() 
	for index, enemy in ipairs(objects.enemies) do 
		if (math.random(100) <= 1) then 
			shot = {} 
			shot.x = enemy.x 
			shot.y = enemy.y 
			shot.active = true 
			shot.speed = math.random(2.5) 
			shot.angle = math.random(6.283) 
			table.insert(objects.enemy.shots, shot) 
		end 
	end 
end 

function update_enemy_shots() 
	for index, shot in ipairs(objects.enemy.shots) do 
		shot.x = shot.x + shot.speed * math.sin(shot.angle) 
		shot.y = shot.y + shot.speed * -math.cos(shot.angle) 
	end 
end 

function divide_asteroids_after_collision_with_player_shots(remAsteroid, remShot) 
	-- collisions 
	for index, shot in ipairs(objects.player.shots) do 
		for i, asteroid in ipairs(objects.asteroids) do 
			size_asteroid = asteroid.size 
			size_shot = 10 
			if (shot.active == true and shot.x + size_shot >= asteroid.body:getX() and shot.x <= asteroid.body:getX() + size_asteroid 
			and shot.y + size_shot >= asteroid.body:getY() and shot.y <= asteroid.body:getY() + size_asteroid) then 
				table.insert(remShot, index) 
				objects.player.score = objects.player.score + 10 
				shot.active = false 
				asteroid.magnitude = asteroid.magnitude - 1 
				local magnitude = asteroid.magnitude 
				local pos_x = asteroid.body:getX() 
				local pos_y = asteroid.body:getY() 

				if (magnitude == 2) then 
					asteroid.size = 40 
					asteroid_new = create_asteroid(pos_x + 20, pos_y + 20, 2, 40, math.random(50) + 500, math.random(math.pi * 2)) 
					asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle))
					table.insert(objects.asteroids, asteroid_new) 
				elseif (magnitude == 1) then 
					asteroid.size = 25 
					asteroid_new = create_asteroid(pos_x + 12.5, pos_y + 12.5, 1, 25, math.random(50) + 500, math.random(math.pi * 2)) 
					asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle))
					table.insert(objects.asteroids, asteroid_new) 
				else 
					table.insert(remAsteroid, i) 
				end 		
			end 
		end 
	end 
end 

function divide_asteroids_after_collision_with_enemy_shots(remAsteroid, remShot) 
	-- collisions 
	for index, shot in ipairs(objects.enemy.shots) do 
		for i, asteroid in ipairs(objects.asteroids) do 
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
					asteroid_new = create_asteroid(pos_x + 20, pos_y + 20, 2, 40, math.random(50) + 500, math.random(6.283)) 
					asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle))
					table.insert(objects.asteroids, asteroid_new) 
				elseif (magnitude == 1) then 
					asteroid.size = 25 
					asteroid_new = create_asteroid(pos_x + 12.5, pos_y + 12.5, 1, 25, math.random(50) + 500, math.random(6.283)) 
					asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle))
					table.insert(objects.asteroids, asteroid_new) 
				else 
					table.insert(remAsteroid, i) 
				end 		
			end 
		end 
	end 
end 



function check_collision_between_enemy_shots_and_player(remShot) 
	-- collisions 
	for index, shot in ipairs(objects.enemy.shots) do 
			size_player_x = objects.player.size.x 
			size_player_y = objects.player.size.y 
			
			size_shot = 10 
			if (shot.active == true and objects.player.active == true and shot.x + size_shot >= objects.player.body:getX() and shot.x <= objects.player.body:getX() + size_player_x 
				and shot.y + size_shot >= objects.player.body:getY() and shot.y <= objects.player.body:getY() + size_player_y) then 
					table.insert(remShot, index) 
					shot.active = false 
					objects.player.respawn = true 
			end 
	end 
end 

function kill_or_respawn_player() 
	
	if(objects.player.respawn == true) then 
		--objects.player.respawn_start_time = love.timer.getTime 
		objects.player.lives = objects.player.lives - 1 
		objects.player.respawn = false 
		objects.player.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") 
	end 
end 

function check_collisions_between_asteroids_and_player(remAsteroid) 
	for index, asteroid in ipairs(objects.asteroids) do 
	
		size_asteroid = asteroid.size 
		size_player_x = objects.player.size.x 
		size_player_y = objects.player.size.y 
		
		if (objects.player.alive == true and objects.player.body:getX() + size_player_x >= asteroid.body:getX() and objects.player.body:getX() <= asteroid.body:getX() + size_asteroid 
			and objects.player.body:getY() + size_player_y >= asteroid.body:getY() and objects.player.body:getY() <= asteroid.body:getY() + size_asteroid) then 
			
			--kill_and_respawn_player() 
			objects.player.respawn = true 
			--love.graphics.print("Game Over", objects.player.body:getX() + 25, objects.player.body:getY() + 25) 
			
			asteroid.magnitude = asteroid.magnitude - 1 
			local magnitude = asteroid.magnitude 
			local pos_x = asteroid.body:getX() 
			local pos_y = asteroid.body:getY() 
			
			if (magnitude == 2) then 
				asteroid.size = 40 
				asteroid_new = create_asteroid(pos_x + 20, pos_y + 20, 2, 40, 50, math.random(math.pi * 2)) 
				asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle)) 
				table.insert(objects.asteroids, asteroid_new) 
			elseif (magnitude == 1) then 
				asteroid.size = 25 
				asteroid_new = create_asteroid(pos_x + 12.5, pos_y + 12.5, 1, 25, 50, math.random(math.pi *2)) 
				asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle)) 
				table.insert(objects.asteroids, asteroid_new) 
			else 
				table.insert(remAsteroid, i) 
			end 
		end 
	end 
end 

function check_collisions_between_asteroids_and_enemy_ship(remAsteroid) 
	for index, asteroid in ipairs(objects.asteroids) do 
		for i, enemy in ipairs(objects.enemies) do 
			size_asteroid = asteroid.size 
			size_enemy_x = enemy.size_x 
			size_enemy_y = enemy.size_y 
		
			if (enemy.alive == true and enemy.x + size_enemy_x >= asteroid.body:getX() and enemy.x <= asteroid.body:getX() + size_asteroid 
				and enemy.y + size_enemy_y >= asteroid.body:getY() and enemy.y <= asteroid.body:getY() + size_asteroid) then 
			
				--love.graphics.print("Game Over", objects.player.body:getX() + 25, objects.player.body:getY() + 25) 
				objects.enemy.alive = false 
				asteroid.magnitude = asteroid.magnitude - 1 
				local magnitude = asteroid.magnitude 
				local pos_x = asteroid.body:getX() 
				local pos_y = asteroid.body:getY() 

				if (magnitude == 2) then 
					asteroid.size = 40 
					asteroid_new = create_asteroid(pos_x + 20, pos_y + 20, 2, 40, 50, math.random(math.pi * 2)) 
					asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle)) 
					table.insert(objects.asteroids, asteroid_new) 
				elseif (magnitude == 1) then 
					asteroid.size = 25 
					asteroid_new = create_asteroid(pos_x + 12.5, pos_y + 12.5, 1, 25, 50, math.random(math.pi *2)) 
					asteroid_new.body:applyForce(asteroid_new.speed * math.sin(asteroid_new.angle), -asteroid_new.speed * math.cos(asteroid_new.angle)) 
					table.insert(objects.asteroids, asteroid_new) 
				else 
					table.insert(remAsteroid, index) 
				end 
			end 
		end 
	end 
end 

function check_collision_between_enemy_shots_and_player(remShot) 
	-- collisions 
		for index, shot in ipairs(objects.enemy.shots) do 
			
			size_player_x = objects.player.size.x 
			size_player_y = objects.player.size.y 
			
			size_shot = 10 
			if (shot.active == true and shot.x + size_shot >= objects.player.body:getX() and shot.x <= objects.player.body:getX() + size_player_x 
				and shot.y + size_shot >= objects.player.body:getY() and shot.y <= objects.player.body:getY() + size_player_y) then 
				table.insert(remShot, index) 
				shot.active = false 
				objects.player.respawn = true 
			end 
		end 
end 

function check_collision_between_player_shots_and_enemies(remShot, remEnemy) -- to implement 
	-- collisions 
		for index, shot in ipairs(objects.player.shots) do 
			for i, enemy in ipairs(objects.enemies) do 
				size_enemy_x = enemy.size_x  
				size_enemy_y = enemy.size_y 
			
				size_shot = 10 
				if (shot.active == true and shot.x + size_shot >= enemy.x and shot.x <= enemy.x + size_enemy_x 
					and shot.y + size_shot >= enemy.y and shot.y <= enemy.y + size_enemy_y) then 
					table.insert(remShot, index) 
					table.insert(remEnemy, i) 
					objects.player.score = objects.player.score + 20 
					shot.active = false 
				end 
			end 
		end 
end 

function check_collision_between_player_and_enemies() 
	
	for i, enemy in ipairs(objects.enemies) do 
		size_enemy_x = enemy.size_x 
		size_enemy_y = enemy.size_y 
	
		size_player_x = objects.player.size.x 
		size_player_y = objects.player.size.y 
	
		if (objects.player.alive == true and objects.player.body:getX() + size_player_x >= enemy.x and objects.player.body:getX() <= enemy.x + size_enemy_x 
			and objects.player.body:getY() + size_player_y >= enemy.y and objects.player.body:getY() <= enemy.y + size_enemy_y) then 
				objects.player.respawn = true 
		end 
	end 
end 

-- draws both enemie's and player's shots 
function draw_shots() 
	-- let's draw our heros shots 
    love.graphics.setColor(255,255,255,255) 
    for i,v in ipairs(objects.player.shots) do 
		if (v.active == true) then 
			love.graphics.draw(pocisk, v.x, v.y) 
			love.graphics.print(v.x, v.x + 10, v.y) 
			love.graphics.print(v.y, v.x + 10, v.y + 10) 
		end 
    end 
	
	for i,v in ipairs(objects.enemy.shots) do 
		if (v.active == true) then 
			love.graphics.draw(pocisk, v.x, v.y) 
			love.graphics.print(v.x, v.x + 10, v.y) 
			love.graphics.print(v.y, v.x + 10, v.y + 10) 
		end 
    end 
end 

function draw_asteroids() 
	for index, asteroid in ipairs(objects.asteroids) do 
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
end

function draw_player() 
	if(objects.player.alive == true and objects.player.respawn == false) then 
		love.graphics.push() 
		love.graphics.draw(statek, objects.player.body:getX(), objects.player.body:getY(), angle, 1, 1, 25, 25) 
		love.graphics.pop() 
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

function remove_actors(remEnemy, remPlayerShot, remEnemyShot, remAsteroid) 
	-- remove the marked enemies 
    for i,v in ipairs(remEnemy) do 
        table.remove(objects.enemies, v) 
    end 

    for i,v in ipairs(remPlayerShot) do 
        table.remove(objects.player.shots, v)  
    end 

	for i,v in ipairs(remEnemyShot) do 
        table.remove(objects.enemy.shots, v) 
    end 
	
	for i,v in ipairs(remAsteroid) do 
        table.remove(objects.asteroids, v) 
    end 
end 

function move_players_shots(dt, remPlayerShot) 
	-- update the shots
    for i,v in ipairs(objects.player.shots) do 

        -- move them up up up
        v.x = v.x + v.dx * dt * 100 
		v.y = v.y + v.dy * dt * 100 

        -- mark shots that are not visible for removal 
        if v.y < 0 then 
            table.insert(remPlayerShot, i) 
        end 
    end
end 

function move_enemies(dt) 
	for index, enemy in ipairs(objects.enemies) do 
	
		enemy.x = enemy.x + enemy.speed * math.sin(enemy.angle) * dt 
		enemy.y = enemy.y + enemy.speed * -math.cos(enemy.angle) * dt 
	
		if(math.random(1000) <= 1) then 
			objects.enemy.angle = math.random(math.pi * 2) 
		end 
	end 
end 

function shoot() 
    local shot = {} 
    shot.x = objects.player.body:getX()--+hero.width/2 
    shot.y = objects.player.body:getY() 
	shot.dx = math.sin(angle) 
	shot.dy = -math.cos(angle) 
	shot.active = true 
	
    table.insert(objects.player.shots, shot) 
end 

function draw_enemies() 
	local x = 0 
	local y = 0 
	for index, enemy in ipairs(objects.enemies) do 
		--love.graphics.print(enemy.x, 0, y) 
		--love.graphics.print(enemy.y, 0, y + 20) 
		--y = y + 50 
		if(enemy.alive == true) then 
			love.graphics.draw(enemy_img, enemy.x, enemy.y) 
		end 
		
	end 
end 

function draw_hud() 
	love.graphics.print("Lives: ", 20, 20) 
	love.graphics.print(objects.player.lives, 70, 20) 
	
	love.graphics.print("Points: ", 20, 30) 
	love.graphics.print(objects.player.score, 70, 30) 
end 

function show_game_over_screen()
	if (objects.player.alive == false) then 
		love.graphics.print("Game Over", 650 / 2, 650 / 2) 
		love.graphics.print("Your score: ", 650 / 2, 650 / 2 + 20) 
		love.graphics.print(objects.player.score, 650 / 2 + 100, 650 / 2 + 20) 
	end 
end 

function control_player(dt) 
	--here we are going to create some keyboard events 
    if love.keyboard.isDown("right") then --press the right arrow key to push the player to the right 
	   angle = angle + dt * math.pi/2 
    elseif love.keyboard.isDown("left") then --press the left arrow key to push the player to the left 
	   angle = angle - dt * math.pi/2 
    elseif love.keyboard.isDown("up") then --press the up arrow key to set the player in the air 
       objects.player.body:applyForce(50 * math.sin(angle), -50 * math.cos(angle)) 
	end 
	
	angle = angle % (2*math.pi) 
end 

function love.keyreleased(key) 
    if (key == " ") then 
        shoot() 
    end 
end 

function start_asteroid_movement() 
	if (asteroids_moving == false) then 
		for index, asteroid in ipairs(objects.asteroids) do 
			asteroid.body:applyForce(asteroid.speed * math.sin(asteroid.angle), -asteroid.speed * math.cos(asteroid.angle)) 
		end 
		asteroids_moving = true 
	end 
end 

function love.load() 
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81    

    objects = {} -- table to hold all our physical objects 

    --let's create a player 
    objects.player = {} 
    objects.player.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around 
	objects.player.alive = true 
	objects.player.size = {} 
	objects.player.size.x = 30 
	objects.player.size.y = 25 
	objects.player.shots = {} 
	objects.player.lives = 3 
	objects.player.points = 0 
	objects.player.respawn = false 
	objects.player.score = 0 
	
	objects.asteroids = {} 
	
	for i = 1, num_asteroids do 
		asteroid = create_asteroid(math.random(500), math.random(500), 3, 60, 50, math.random(6.283)) 
		table.insert(objects.asteroids, asteroid) 
    end 
	
	objects.enemy = {} 
	objects.enemy.shots = {} 
	objects.enemies = {} 
	
	for i = 1, num_enemies do 
		enemy = create_enemy(math.random(500), math.random(500), 1, 45, 18, 20, math.random(6.283)) 
		table.insert(objects.enemies, enemy) 
	end 
	
    bg = love.graphics.newImage("bg.png") 
	statek = love.graphics.newImage("statek.png") 
	pocisk = love.graphics.newImage("pocisk.png") 
	duza_asteroida = love.graphics.newImage("duza_asteroida.png") 
	srednia_asteroida = love.graphics.newImage("srednia_asteroida.png") 
	mala_asteroida = love.graphics.newImage("mala_asteroida.png") 
	enemy_img = love.graphics.newImage("enemy.png") 
	mouse_pointer = love.graphics.newImage("mouse_pointer.png") 
end

function love.update(dt)
    
	if (game_state == 0) then 
		update_main_menu_screen() 
	elseif (game_state == 1) then 
		update_credits_screen() 
	elseif (game_state == 2) then 
		world:update(dt) 
	
		local remEnemy = {} 
		local remPlayerShot = {} 
		local remEnemyShot = {} 
		local remAsteroid = {} 
	
		check_all_outside_screen() 
		control_player(dt) 
	
		start_asteroid_movement() 
	
		divide_asteroids_after_collision_with_player_shots(remAsteroid, remPlayerShot) 
		divide_asteroids_after_collision_with_enemy_shots(remAsteroid, remEnemyShot) 
	
		check_collisions_between_asteroids_and_player(remAsteroid) 
		check_collisions_between_asteroids_and_enemy_ship(remAsteroid) 
	
		check_collision_between_enemy_shots_and_player(remEnemyShot) 
		check_collision_between_player_shots_and_enemies(remPlayerShot, remEnemy) 
		check_collision_between_player_and_enemies() 
	
		move_players_shots(dt, remPlayerShot) 
		move_enemies(dt) 
	
		kill_or_respawn_player() 
		enemies_shoot() 
		update_enemy_shots() 
		remove_actors(remEnemy, remPlayerShot, remEnemyShot, remAsteroid) 
	else 
		show_game_over_screen() 
	end 
end

function love.draw() 
    
	if (game_state == 0) then 
		show_main_menu_screen() 
	elseif (game_state == 1) then 
		show_credits_screen() 
	elseif (game_state == 2) then 
		-- let's draw a background 
		love.graphics.setColor(255,255,255,255) 
		love.graphics.draw(bg) 
	
		draw_player() 
		draw_asteroids() 
		draw_shots() 
		draw_enemies() 
	
		love.graphics.print(angle, 100, 100) 
	
		draw_hud() 
	else 
		show_game_over_screen() 
	end 
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


