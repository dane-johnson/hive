(local std (include :std))
(require-macros :std-macros)

(local mt (include :multitouch))

(local {: hex->pixel
        : pixel->hex
        : draw-hex
        : debug-hex}
       (include :hex))

(local *zoom-speed* 10.0)
(local *mobile*
       (std.some #(= $ (love.system.getOS)) ["Android" "iOS"]))

(var origin [400 300])
(var scale 100.0)

(var mode :point)

(local board {})

(fn hex->string
  [[q r s]]
  (string.format "<%d,%d,%d>" q r s))

(fn string->hex
  [str]
  (std.map tonumber [(string.match str "<(-?%d+),(-?%d+),(-?%d+)>")]))

(fn board-insert
  [[q r s] val]
  (assert (= (+ q r s) 0) (.. "Error, " q " + " r " + " s " != 0"))
  (tset board (hex->string [q r s]) val))

(fn board-iterate
  []
  (var curr (next board))
  (fn board-iterator
    []
    (let [prev curr]
      (if prev
        (do
          (set curr (next board prev))
          (values (string->hex prev) (. board prev)))
        nil))))

(fn love.load
  []
  (std.apply love.mouse.setPosition origin)
  (std.foreach board-insert
               [[0 0 0] [1 0 -1] [0 1 -1]]
               [[:white :queen] [:black :queen] [:black :ant]]))

(fn love.update
  [dt]
  (mt.update dt))

(fn love.wheelmoved
  [_ y]
  (set scale (math.max
              (+ scale (* *zoom-speed* y))
              2.0)))

(fn pan
  [x y]
  (let [[ox oy] origin]
    (set origin
         [(+ x ox)
          (+ y oy)])))

(fn love.mousemoved
  [x y dx dy]
  (match mode
    :point nil
    :pan (pan dx dy)))

(fn love.mousepressed
  [x y button]
  (when (not *mobile*)
    (match button
      1 (set mode :drag)
      3 (set mode :pan))))

(fn love.mousereleased
  [x y button]
  (when (not *mobile*) 
    (match button
      1 (do
          (set mode :point)
          (board-insert (pixel->hex [(love.mouse.getPosition)] origin scale) [:white :queen]))
      3 (set mode :point))))

(fn mt.tapped
  [x y]
  (board-insert (pixel->hex [x y] origin scale) [:white :queen]))

(fn mt.dragged
  [x y dx dy]
  (set mode :drag))

(fn mt.two-finger-drag
  [x y dx dy]
  (pan dx dy))

(fn mt.dropped
  [x y]
  (board-insert (pixel->hex [x y] origin scale) [:white :queen])
  (set mode :point))

(fn mt.pinched
  [diff]
  (set scale (math.max
              (+ scale diff)
              2.0)))

(fn love.touchpressed
  [id x y]
  (mt.raw-touchpressed id x y))

(fn love.touchreleased
  [id x y]
  (mt.raw-touchreleased id x y))

(fn love.touchmoved
  [id x y dx dy]
  (mt.raw-touchmoved id x y dx dy))

(fn love.draw
  [dt]
  (each [hex-coord hex-type (board-iterate)]
    (draw-hex (hex->pixel hex-coord origin scale) origin scale)
                                        ;(debug-hex hex-coord (hex->pixel hex-coord))
    )
  (when (= mode :drag)
    (draw-hex [(love.mouse.getPosition)] origin scale))
  (let [[q r s] (pixel->hex [(love.mouse.getPosition)] origin scale)]
    (love.graphics.print (hex->string [q r s]))))
