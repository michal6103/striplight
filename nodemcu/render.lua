-- Renderer module that generates data
-- @Input: numebr of LEDs


render = {
	led_count = 1,
	strip = nil
}

function render.init(strip, led_count)
	render.led_count = led_count
    print("LED count: " .. render.led_count)
    render.strip = strip
end

function render.nextFrame()
	-- Function generates data that will be sent
	return "RGB"
end

