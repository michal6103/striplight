require "config"
require "network"
require "time"
require "render_rainbow"
require "strip_apa102"


STA_GOTIP = 5
TIMER_NETWORK = 0   -- Timer used for network event
TIMER_RENDER = 1     -- Timer used for color change
TIMER_TIME = 2      -- Timer used for gettin time regularely

MODE_MORNING = CONFIG.MODE_MORNING
MODE_DAY = CONFIG.MODE_DAY
MODE_EVENING = CONFIG.MODE_EVENING
MODE_NIGHT = CONFIG.MODE_NIGHT


-- TODO; create brightnessloop event

-- Setup timer event trying to connect to wifi
network = Network
network.initWifi(CONFIG.SSID, CONFIG.PASSWORD)
network.connectLoop()

-- Setup timer to get time over internet 
time = Time
time.getTimeLoop(CONFIG.TIME_HOST)

-- Setup LED strip 
strip = strip_apa102;
strip.init()

-- Start renderer
render = render_rainbow
render.init(strip, CONFIG.LED_COUNT)
tmr.alarm(TIMER_RENDER, 2000, 1, render.nextFrame)
-- tmr.stop(TIMER_RENDER)
