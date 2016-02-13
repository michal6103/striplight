-- Rendered module that shifts rainbow over all LEDs
require "color"


render_rainbow = {
	hue_state = 0,
	led_count = 1,
    strip = nil,
   	s = 255,
	v = 255,
    brightness = 31
}

function render_rainbow.init(strip,led_count)
	render_rainbow.led_count = led_count
    print("LED count: " .. render_rainbow.led_count)
    render_rainbow.strip = strip
end

function render_rainbow.nextFrame()
	local data_table = {}
	local r, g, b

    local start = tmr.now()
	for led = 1, render_rainbow.led_count do
		r, g, b = Color.hsvToRgb(led+render_rainbow.hue_state, render_rainbow.s, render_rainbow.v)
		-- data for every LED in BGR format
		data_table[led] = string.char(b) .. string.char(g) ..string.char(r)
	end
    render_rainbow.hue_state = render_rainbow.hue_state + 1
    if render_rainbow.hue_state >255 then
        render_rainbow.hue_state = 0
    end
    local data = table.concat(data_table)
    local frame_gener = tmr.now() - start
    print("Data gener: " .. frame_gener)
	render_rainbow.strip.write(render_rainbow.brightness, data)
    local frame_send = tmr.now() - start
    print("Frame send: " .. frame_send)
end

