
local t = getmetatable(vec2())
t.copy = function(v) return vec2(v.x, v.y) end
t.unpack = function(v) return v.x, v.y end
--
function math.round(num) return math.floor(num + 0.5) end
--
function clamp (n, a, b) return math.max(math.min(n, b), a) end
