-- Renderer module that generates data
-- @Input: numebr of LEDs


render = {
	led_count = 1
}

function render:init(led_count, rendered_function)
	self.led_count = led_count
	render.nextFrame = render_function
end

function render.nextFrame()
end

