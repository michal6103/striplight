
require "nodemcu_dummy"

require "network"
require "time"
require "strip_pwm"
require "strip_apa102"
require "config"
require "color"
require "render"
require "render_rainbow"

STA_GOTIP = 5
TIMER_NETWORK = 0   -- Timer used for network event
TIMER_RENDER = 1     -- Timer used for color change
TIMER_TIME = 2      -- Timer used for gettin time regularely

MODE_MORNING = CONFIG.MODE_MORNING
MODE_DAY = CONFIG.MODE_DAY
MODE_EVENING = CONFIG.MODE_EVENING
MODE_NIGHT = CONFIG.MODE_NIGHT


-- TODO; create brightnessloop event


function rotateColorsCallback()
	-- TODO: Replace this function by renderer module
    if hue == nil then
        hue = 0
    end
    local r, g, b
	-- in morning and day we use full spectre
	if time >= MODE_MORNING then
		s = 255
		v = 127
	elseif time >= MODE_DAY then
    	s = 127
		v = 255
	elseif time >= MODE_EVENING then
		s = 255
		v = 127
	elseif time >= MODE_NIGHT then
		s = 255
		v = 63
	end

	-- in evening and night there is no  blue and minimal green
	if time >= MODE_EVENING or time >= MODE_NIGHT then
		if  hue > 21 then
			hue = 0
		end
	end	
    if hue >= 255 then
        hue = 0
    end

    r, g, b = Color.hsvToRgb(hue, s, v)
    -- print("HSV",hue,255,255)
    -- print("RGB",r,g,b)
    strip:setRGB(r, g, b)

    hue = hue + 1
end

network = Network
network.initWifi(CONFIG.SSID, CONFIG.PASSWORD)
-- Sets up timer event trying to connect to wifi
network.connectLoop()

time = Time
time.startGetTimeLoop()

strip = strip_apa102;
strip.init()
-- Start renderer
render = render_rainbow
tmr.alarm(TIMER_RENDER, 1000, 1, render.nextFrame)


