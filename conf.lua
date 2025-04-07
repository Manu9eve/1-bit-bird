--WINDOW FIXED RESOLUTION
CANVAS_WIDTH = 240
CANVAS_HEIGHT = 320

PIPE_WIDTH = 32
PIPE_HEIGHT = 320

function love.conf(t)
	t.window.title = "1-BIT Bird"
	t.window.icon = "icon.png"
	
	t.window.width = 480
	t.window.height = 640
	
	t.window.fullscreen = false
end
