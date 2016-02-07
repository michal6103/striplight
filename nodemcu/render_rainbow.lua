-- Rendered module that shifts rainbow over all LEDs
require "color"
require "config"


render_rainbow = {
	hue_state = 0,
	led_count = 1,
	s = 255,
	v = 255
}

function render_rainbow.init(led_count)
	render_rainbow.led_count = led_count
end


function render_rainbow.nextFrame()
	local data_table = {}
	local r, g, b

	for led = 1, render_rainbow.led_count do
		r, g, b = Color.hsvToRgb(led+render_rainbow.hue_state, render_rainbow.s, render_rainbow.v)
		print(r, g, b)
		-- data for every LED in BGR format
		data_table[led] = b .. g .. r
	end

	return table.concat(data_table)
end
