require "src.rect"
require "../conf"

bird = {}

local jump = love.audio.newSource("sfx/jump.wav", "static")

function bird.init()
	bird.rect = rect( 0, 0, 16, 16 )
	bird.rect.x = (CANVAS_WIDTH/2) - bird.rect.height/2
	bird.rect.y = (CANVAS_HEIGHT/2) - bird.rect.width/2
	
	bird.gravity = 400
	
	bird.ySpeed = 0
	bird.jumpHeight = 200
	bird.maxFallSpeed = 500
	
	bird.sprite = love.graphics.newImage("gfx/bird.png")
end



function bird.update(delta)
	bird.ySpeed = bird.ySpeed + bird.gravity * delta
	
	if bird.ySpeed > bird.maxFallSpeed then
		bird.ySpeed = bird.maxFallSpeed
	end
	
	bird.rect.y = bird.rect.y + bird.ySpeed * delta
end

function bird.draw()
	love.graphics.draw(bird.sprite, bird.rect.x + bird.rect.width/2, bird.rect.y + bird.rect.height/2, 1 * (bird.ySpeed / bird.maxFallSpeed), bird.rect.width/16, bird.rect.height/16, 8, 8)
end

function bird.handleInput(key)
	if key == "space" then
		bird.ySpeed = -bird.jumpHeight
		jump:play()
	end
end

return bird
