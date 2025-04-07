require "src.bird"
require "src.rect"
require "conf"

local tlfres = require "src.tlfres"

local title = true

function love.mouse.getPosition() -- Override the standard function with our helper function
   return TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
end

function love.load()
	
	--window setup
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	font = love.graphics.newFont("gfx/RasterForgeRegular-JpBgm.ttf", 32, "none")
	explosion = love.audio.newSource("sfx/explosion.wav", "static")
	newBest = love.audio.newSource("sfx/newBest.wav", "static")
	
	--default pipe layout
	pipes={ rect(240, -224, PIPE_WIDTH, PIPE_HEIGHT), rect(240, 224, PIPE_WIDTH, PIPE_HEIGHT) }
	pipeTimer = 0
	pipeSpawnInterval = 2
	
	pipe = love.graphics.newImage("gfx/pipe.png")
	ground = love.graphics.newImage("gfx/ground.png")
	
	if love.filesystem.getInfo("score.dat") then
		best = tonumber(love.filesystem.read("score.dat"), 10)
		if best == nil then
			best = 0
		end
	else
		best = 0
	end
	
	score = 0
	
	bird.init()
	
end

function restart()

	if score > best then
		best = math.floor(score)
		newBest:play()
		love.filesystem.write("score.dat", tostring(math.floor(score)))
	end
	
	--default pipe layout
	pipes={ rect(240, -224, PIPE_WIDTH, PIPE_HEIGHT), rect(240, 224, PIPE_WIDTH, PIPE_HEIGHT) }
	pipeTimer = 0
	
	bird.rect.x = (CANVAS_WIDTH/2) - bird.rect.height/2
	bird.rect.y = (CANVAS_HEIGHT/2) - bird.rect.width/2
	bird.ySpeed = 0
	
	title = true
end

function title_screen()
	love.graphics.setColor(love.math.colorFromBytes(34,35,35))
	love.graphics.print("1-BIT BIRD", font, CANVAS_WIDTH/2-font:getWidth("1-BIT BIRD")/2, 48, 0, 1, 1)
	love.graphics.print("BEST: " .. best, font, CANVAS_WIDTH/2-font:getWidth("BEST: " .. best)/4, CANVAS_HEIGHT - 128 , 0, 0.5, 0.5)
	love.graphics.print("TAP TO PLAY", font, CANVAS_WIDTH/2-font:getWidth("TAP TO PLAY")/4, CANVAS_HEIGHT - 64 , 0, 0.5, 0.5)
end

function love.update(delta)
	
	if title then
		return
	end
	
	
	pipeTimer = pipeTimer + 1 * delta
	score = score + 1 * delta
	
	if pipeTimer >= pipeSpawnInterval then
		local pipeY = math.random(-PIPE_HEIGHT + 64, -128)
		table.insert(pipes, rect(CANVAS_WIDTH, pipeY, PIPE_WIDTH, PIPE_HEIGHT))
		table.insert(pipes, rect(CANVAS_WIDTH, pipeY + PIPE_HEIGHT + 48, PIPE_WIDTH, PIPE_HEIGHT))
		
		pipeTimer = 0
	end
	
	bird.update(delta)
	
	if bird.rect.y + bird.rect.height >= 288 then
		explosion:play()
		restart()
	end
	
	if bird.rect.y < 0 then
		bird.rect.y = 0
	end
	
	for i,v in ipairs(pipes) do
	
		v.x= v.x - 80 * delta
		
		if collide(bird.rect, v) then
			explosion:play()
			restart()
		end
		
		if v.x + v.width < 0 then
			table.remove(pipes, i)
		end
	end
end

function love.draw()

	tlfres.beginRendering(CANVAS_WIDTH, CANVAS_HEIGHT)

	love.graphics.clear(love.math.colorFromBytes(240,246,240))
	
	if title then
		title_screen()
	end
	
	love.graphics.setColor(1, 1, 1)
	
	for i,v in ipairs(pipes) do
		if i%2 == 1 then
			love.graphics.draw(pipe, v.x, v.y, 0, 1, -1, 0, PIPE_HEIGHT )
		else
			love.graphics.draw(pipe, v.x, v.y, 0, 1, 1)
		end	
	end
	
	love.graphics.draw(ground, 0, 288)
	bird.draw()
	
	--HUD--
	love.graphics.setColor(love.math.colorFromBytes(34,35,35))
	local scoreText = tostring(math.floor(score))
	local textWidth = font:getWidth(scoreText)
	love.graphics.print(scoreText, font, CANVAS_WIDTH/2 - textWidth / 2, 16)
	
	tlfres.endRendering()
end

function love.keypressed(key)

	if key == "escape" then
		love.event.quit()
	end
	
	if key == "f" then
		love.window.setFullscreen((not love.window.getFullscreen()))
	end
	
	if key == "space" and title == true then
		title = false
		score = 0
	end	
	
	if not title then
		bird.handleInput(key)
	end
	
end

function love.mousepressed(x, y, button, istouch, presses)
	if button == 1 then
		if title then
			title = false
			score = 0
		else
			bird.handleInput("space")
		end
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
		if title then
			title = false
			score = 0
		else
			bird.handleInput("space")
		end	
end
