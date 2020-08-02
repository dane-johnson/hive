(local std (include :std))
(require-macros :std-macros)

(local *forward* [(math.sqrt 3) (/ (math.sqrt 3) 2) 0 (/ 3 2)])
(local *inverse* [(/ (math.sqrt 3) 3) (/ -1 3) 0 (/ 2 3)])

(var origin [400 300])

(var scale 100.0)

(fn hex->pixel
  [[q r s]]
  (let [[ox oy] origin
        [f0 f1 f2 f3] *forward*]
    [(+ (* scale (+ (* f0 q) (* f1 r))) ox)
     (+ (* scale (+ (* f2 q) (* f3 r))) oy)]))

(fn math.round
  [x]
  (let [[i f] [(math.modf x)]]
    (if (< f 0.5)
        i
        (+ 1 i))))

(fn hex-round
  [hex-coords]
  ;; Rounding isn't straightforwards...
  (let [[q r s] (std.map math.round hex-coords)
        [qd rd sd] (std.map (fn diff [x y] (math.abs (- x y))) [q r s] hex-coords)]
    (cond
     (and (> qd rd) (> qd sd)) [(- (+ r s)) r s]
     (> rd sd) [q (- (+ q s)) s]
     :else [q r (- (+ q r))])))

(fn pixel->hex
  [[x y]]
  (let [[ox oy] origin
        [ux uy] [(/ (- x ox) scale) (/ (- y oy) scale)]
        [r0 r1 r2 r3] *inverse*
        [q r] [(+ (* r0 ux) (* r1 uy))
               (+ (* r2 ux) (* r3 uy))]]
    (hex-round [q r (- (+ q r))])))

(fn ro->ri
  [ro]
  ;; Ir = cos(pi/6) * Ro = sqrt(3) / 2 * ro
  (* ro (/ (math.sqrt 3) 2)))

(fn draw-hex
  [[x y]]
  (let [ro scale
        ri (ro->ri scale)]
    (love.graphics.polygon
     :line
     x (- y ro)
     (+ x ri) (- y (/ ro 2))
     (+ x ri) (+ y (/ ro 2))
     x (+ y ro)
     (- x ri) (+ y (/ ro 2))
     (- x ri) (- y (/ ro 2)))))

(fn debug-hex
  [[q r s] [x y]]
  (love.graphics.print
   (.. q ", " r ", " s)
   x y))

(fn set-origin
  [new-origin]
  (set origin new-origin))

(fn set-scale
  [new-scale]
  (set scale new-scale))

{:hex->pixel hex->pixel
 :pixel->hex pixel->hex
 :draw-hex draw-hex
 :debug-hex debug-hex
 :origin origin
 :scale scale
 :set-origin set-origin
 :set-scale set-scale}
