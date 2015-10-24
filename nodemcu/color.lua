require "math"
Color = {}

function Color.hsvToRgb(h, s, v)
  local r, g, b

  local i = h / 43;
  local f = (h - (i * 43)) * 6;
  local p = (v * (255 - s)) / 255;
  local q = (v * (255 - ((f * s) / 255))) / 255;
  local t = (v * (255 - (((255 - f) * s) / 255))) / 255;

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r, g, b
end

