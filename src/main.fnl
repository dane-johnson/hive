(local std (include :std))
(require-macros :std-macros)

(local {: hex->pixel
        : pixel->hex
        : draw-hex
        : debug-hex
        : origin
        : scale
        : set-origin
        : set-scale} (include :hex))

;; https://www.redblobgames.com/grids/hexagons/

(local *zoom-speed* 10.0)

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

(fn hex=
  [[q1 r1 s1] [q2 r2 s2]]
  (and (= q1 q2)
       (= r1 r2)
       (= s1 s2)))

(fn love.load
  []
  (std.apply love.mouse.setPosition origin)
  (std.foreach board-insert
               [[0 0 0] [1 0 -1] [0 1 -1]]
               [[:white :queen] [:black :queen] [:black :ant]]))

(fn love.update
  [dt]
  ;; Pass
  )

(fn love.wheelmoved
  [_ y]
  (set-scale (math.max
              (+ scale (* *zoom-speed* y))
              2.0)))

(fn pan
  [x y]
  (let [[ox oy] origin]
    (set-origin
         [(+ x ox)
          (+ y oy)])))

(fn love.mousemoved
  [x y dx dy]
  (match mode
    :point nil
    :pan (pan dx dy)))

(fn love.mousepressed
  [x y button]
  (match button
    1 (set mode :drag)
    3 (set mode :pan)))

(fn love.mousereleased
  [x y button]
  (match button
    1 (do
        (set mode :point)
        (board-insert (pixel->hex [(love.mouse.getPosition)]) [:white :queen]))
    3 (set mode :point)))

(fn love.draw
  [dt]
  (each [hex-coord hex-type (board-iterate)]
    (draw-hex (hex->pixel hex-coord))
    ;(debug-hex hex-coord (hex->pixel hex-coord))
    )
  (when (= mode :drag)
    (draw-hex [(love.mouse.getPosition)]))
  (let [[q r s] (pixel->hex [(love.mouse.getPosition)])]
    (love.graphics.print (hex->string [q r s]))))
