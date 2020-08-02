package.preload["hex"] = package.preload["hex"] or function()
  local std = require("std")
  local _2aforward_2a = {math.sqrt(3), (math.sqrt(3) / 2), 0, (3 / 2)}
  local _2ainverse_2a = {(math.sqrt(3) / 3), (-1 / 3), 0, (2 / 3)}
  local origin = {400, 300}
  local scale = 100
  local function hex__3epixel(_0_0)
    local _1_ = _0_0
    local q = _1_[1]
    local r = _1_[2]
    local s = _1_[3]
    local _2_ = origin
    local ox = _2_[1]
    local oy = _2_[2]
    local _3_ = _2aforward_2a
    local f0 = _3_[1]
    local f1 = _3_[2]
    local f2 = _3_[3]
    local f3 = _3_[4]
    return {((scale * ((f0 * q) + (f1 * r))) + ox), ((scale * ((f2 * q) + (f3 * r))) + oy)}
  end
  math.round = function(x)
    local _1_ = {math.modf(x)}
    local i = _1_[1]
    local f = _1_[2]
    if (f < 0.5) then
      return i
    else
      return (1 + i)
    end
  end
  local function hex_round(hex_coords)
    local _1_ = std.map(math.round, hex_coords)
    local q = _1_[1]
    local r = _1_[2]
    local s = _1_[3]
    local function diff(x, y)
      return math.abs((x - y))
    end
    local _2_ = std.map(diff, {q, r, s}, hex_coords)
    local qd = _2_[1]
    local rd = _2_[2]
    local sd = _2_[3]
    if ((qd > rd) and (qd > sd)) then
      return {( - (r + s)), r, s}
    else
      if (rd > sd) then
        return {q, ( - (q + s)), s}
      else
        if "else" then
          return {q, r, ( - (q + r))}
        else
          return error("No matching std.cond clause")
        end
      end
    end
  end
  local function pixel__3ehex(_1_0)
    local _2_ = _1_0
    local x = _2_[1]
    local y = _2_[2]
    local _3_ = origin
    local ox = _3_[1]
    local oy = _3_[2]
    local _4_ = {((x - ox) / scale), ((y - oy) / scale)}
    local ux = _4_[1]
    local uy = _4_[2]
    local _5_ = _2ainverse_2a
    local r0 = _5_[1]
    local r1 = _5_[2]
    local r2 = _5_[3]
    local r3 = _5_[4]
    local _6_ = {((r0 * ux) + (r1 * uy)), ((r2 * ux) + (r3 * uy))}
    local q = _6_[1]
    local r = _6_[2]
    return hex_round({q, r, ( - (q + r))})
  end
  local function ro__3eri(ro)
    return (ro * (math.sqrt(3) / 2))
  end
  local function draw_hex(_2_0)
    local _3_ = _2_0
    local x = _3_[1]
    local y = _3_[2]
    local ro = scale
    local ri = ro__3eri(scale)
    return love.graphics.polygon("line", x, (y - ro), (x + ri), (y - (ro / 2)), (x + ri), (y + (ro / 2)), x, (y + ro), (x - ri), (y + (ro / 2)), (x - ri), (y - (ro / 2)))
  end
  local function debug_hex(_3_0, _4_0)
    local _4_ = _3_0
    local q = _4_[1]
    local r = _4_[2]
    local s = _4_[3]
    local _5_ = _4_0
    local x = _5_[1]
    local y = _5_[2]
    return love.graphics.print((q .. ", " .. r .. ", " .. s), x, y)
  end
  local function set_origin(new_origin)
    origin = new_origin
    return nil
  end
  local function set_scale(new_scale)
    scale = new_scale
    return nil
  end
  return {["debug-hex"] = debug_hex, ["draw-hex"] = draw_hex, ["hex->pixel"] = hex__3epixel, ["pixel->hex"] = pixel__3ehex, ["set-origin"] = set_origin, ["set-scale"] = set_scale, origin = origin, scale = scale}
end
local std = nil
package.preload["std"] = package.preload["std"] or function()
  local std = {}
  local function _0_(...)
    return nil
  end
  std["not"] = function(x)
    assert((nil ~= x), ("Missing argument %s on %s:%s"):format("x", "./std.fnl", 6))
    return not x
  end
  std["empty?"] = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 11))
    return (#s == 0)
  end
  std.comp = function(f, ...)
    assert((nil ~= f), ("Missing argument %s on %s:%s"):format("f", "./std.fnl", 16))
    local args = {...}
    if std["empty?"](args) then
      return f
    else
      local function _1_(x)
        return f(std.comp(unpack(args))(x))
      end
      return _1_
    end
  end
  std.take = function(n, s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 24))
    assert((nil ~= n), ("Missing argument %s on %s:%s"):format("n", "./std.fnl", 24))
    local arr = {}
    for i = 1, n do
      table.insert(arr, s[i])
    end
    return arr
  end
  std.drop = function(n, s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 32))
    assert((nil ~= n), ("Missing argument %s on %s:%s"):format("n", "./std.fnl", 32))
    local arr = {}
    for i = (n + 1), #s do
      table.insert(arr, s[i])
    end
    return arr
  end
  std.first = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 40))
    return s[1]
  end
  std.second = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 45))
    return s[2]
  end
  std.third = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 50))
    return s[3]
  end
  std.fourth = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 55))
    return s[4]
  end
  std.rest = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 60))
    return std.drop(1, s)
  end
  std.last = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 65))
    return s[#s]
  end
  std.butlast = function(s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 70))
    return std.take((#s - 1), s)
  end
  std.apply = function(f, ...)
    assert((nil ~= f), ("Missing argument %s on %s:%s"):format("f", "./std.fnl", 75))
    if (#{...} == 1) then
      return f(unpack(std.first({...})))
    else
      return f(unpack(std.butlast({...})), unpack(std.last({...})))
    end
  end
  std.cons = function(v, s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 82))
    assert((nil ~= v), ("Missing argument %s on %s:%s"):format("v", "./std.fnl", 82))
    local tbl = {v}
    for _, v0 in ipairs(s) do
      table.insert(tbl, v0)
    end
    return tbl
  end
  std["every?"] = function(p, s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 90))
    assert((nil ~= p), ("Missing argument %s on %s:%s"):format("p", "./std.fnl", 90))
    if std["empty?"](s) then
      return true
    else
      if p(std.first(s)) then
        return std["every?"](p, std.rest(s))
      else
        if "else" then
          return false
        else
          return error("No matching std.cond clause")
        end
      end
    end
  end
  std.foldr = function(f, k, s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 98))
    assert((nil ~= k), ("Missing argument %s on %s:%s"):format("k", "./std.fnl", 98))
    assert((nil ~= f), ("Missing argument %s on %s:%s"):format("f", "./std.fnl", 98))
    if std["empty?"](s) then
      return k
    else
      return f(std.first(s), std.foldr(f, k, std.rest(s)))
    end
  end
  std.foldl = function(f, k, s)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 104))
    assert((nil ~= k), ("Missing argument %s on %s:%s"):format("k", "./std.fnl", 104))
    assert((nil ~= f), ("Missing argument %s on %s:%s"):format("f", "./std.fnl", 104))
    if std["empty?"](s) then
      return k
    else
      return std.foldl(f, f(k, std.first(s)), std.rest(s))
    end
  end
  std.interleave = function(...)
    if std["every?"](std.comp(std["not"], std["empty?"]), {...}) then
      return std.cons(std.map(std.first, {...}), std.apply(std.interleave, std.map(std.rest, {...})))
    else
      return {}
    end
  end
  std.map = function(f, s, ...)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 118))
    assert((nil ~= f), ("Missing argument %s on %s:%s"):format("f", "./std.fnl", 118))
    local tbl = {}
    if std["empty?"]({...}) then
      for _, v in ipairs(s) do
        table.insert(tbl, f(v))
      end
    else
      for _, vs in ipairs(std.interleave(s, ...)) do
        table.insert(tbl, std.apply(f, vs))
      end
    end
    return tbl
  end
  std.foreach = function(f, s, ...)
    assert((nil ~= s), ("Missing argument %s on %s:%s"):format("s", "./std.fnl", 130))
    assert((nil ~= f), ("Missing argument %s on %s:%s"):format("f", "./std.fnl", 130))
    for _, vs in ipairs(std.interleave(s, ...)) do
      std.apply(f, vs)
    end
    return nil
  end
  std.kvs = function(t)
    assert((nil ~= t), ("Missing argument %s on %s:%s"):format("t", "./std.fnl", 137))
    local function _1_()
      if k then
        return loop(std.cons(tbl, {k, t[k]}), next(t, k))
      else
        return tbl
      end
    end
    return __fnl_global__let_2a(loop, {tbl, {}, k, next(t)}, _1_())
  end
  std.keys = function(t)
    assert((nil ~= t), ("Missing argument %s on %s:%s"):format("t", "./std.fnl", 145))
    return std.map(std.first, std.kvs(t))
  end
  std.vals = function(t)
    assert((nil ~= t), ("Missing argument %s on %s:%s"):format("t", "./std.fnl", 149))
    return std.map(std.second, std.kvs(t))
  end
  return std
end
std = require("std")
local _0_ = require("hex")
local debug_hex = _0_["debug-hex"]
local draw_hex = _0_["draw-hex"]
local hex__3epixel = _0_["hex->pixel"]
local origin = _0_["origin"]
local pixel__3ehex = _0_["pixel->hex"]
local scale = _0_["scale"]
local set_origin = _0_["set-origin"]
local set_scale = _0_["set-scale"]
local _2azoom_speed_2a = 10
local mode = "point"
local board = {}
local function hex__3estring(_1_0)
  local _2_ = _1_0
  local q = _2_[1]
  local r = _2_[2]
  local s = _2_[3]
  return string.format("<%d,%d,%d>", q, r, s)
end
local function string__3ehex(str)
  return std.map(tonumber, {string.match(str, "<(-?%d+),(-?%d+),(-?%d+)>")})
end
local function board_insert(_2_0, val)
  local _3_ = _2_0
  local q = _3_[1]
  local r = _3_[2]
  local s = _3_[3]
  assert(((q + r + s) == 0), ("Error, " .. q .. " + " .. r .. " + " .. s .. " != 0"))
  board[hex__3estring({q, r, s})] = val
  return nil
end
local function board_iterate()
  local curr = next(board)
  local function board_iterator()
    local prev = curr
    if prev then
      curr = next(board, prev)
      return string__3ehex(prev), board[prev]
    else
      return nil
    end
  end
  return board_iterator
end
local function hex_3d(_3_0, _4_0)
  local _4_ = _3_0
  local q1 = _4_[1]
  local r1 = _4_[2]
  local s1 = _4_[3]
  local _5_ = _4_0
  local q2 = _5_[1]
  local r2 = _5_[2]
  local s2 = _5_[3]
  return ((q1 == q2) and (r1 == r2) and (s1 == s2))
end
love.load = function()
  std.apply(love.mouse.setPosition, origin)
  return std.foreach(board_insert, {{0, 0, 0}, {1, 0, -1}, {0, 1, -1}}, {{"white", "queen"}, {"black", "queen"}, {"black", "ant"}})
end
love.update = function(dt)
end
love.wheelmoved = function(_, y)
  return set_scale(math.max((scale + (_2azoom_speed_2a * y)), 2))
end
local function pan(x, y)
  local _5_ = origin
  local ox = _5_[1]
  local oy = _5_[2]
  return set_origin({(x + ox), (y + oy)})
end
love.mousemoved = function(x, y, dx, dy)
  local _5_0 = mode
  if (_5_0 == "point") then
    return nil
  elseif (_5_0 == "pan") then
    return pan(dx, dy)
  end
end
love.mousepressed = function(x, y, button)
  local _5_0 = button
  if (_5_0 == 1) then
    mode = "drag"
    return nil
  elseif (_5_0 == 3) then
    mode = "pan"
    return nil
  end
end
love.mousereleased = function(x, y, button)
  local _5_0 = button
  if (_5_0 == 1) then
    mode = "point"
    return board_insert(pixel__3ehex({love.mouse.getPosition()}), {"white", "queen"})
  elseif (_5_0 == 3) then
    mode = "point"
    return nil
  end
end
love.draw = function(dt)
  for hex_coord, hex_type in board_iterate() do
    draw_hex(hex__3epixel(hex_coord))
  end
  if (mode == "drag") then
    draw_hex({love.mouse.getPosition()})
  end
  local _6_ = pixel__3ehex({love.mouse.getPosition()})
  local q = _6_[1]
  local r = _6_[2]
  local s = _6_[3]
  return love.graphics.print(hex__3estring({q, r, s}))
end
return love.draw
