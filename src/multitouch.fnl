(require-macros :std-macros)
(local std (include :std))

(local mt {})

;; Types:
;; - none: No fingers are down, fires no events
;; - tap: up and down of the same finger in rapid movement
;; - drag: press and hold of one finger with intent to move it
;; - drop: releasing a long held finger
;; - two-finger-drag: press and hold of two fingers, keeping relative distance the same
;; - pinch: press and hold of two fingers, moving them apart (-) or together (+)

(local *tap-time* 0.1)

(local *pinch-threshold* 13)

(local fingers {})

(fn call-hook
  [f ...]
  (when f
    (f ...)))

(fn square [x] (* x x))

(fn distance
  [f1 f2]
  (math.sqrt (+ (square (- f1.x f2.x)) (square (- f1.y f2.y)))))

(fn mid
  [f1 f2]
  [(/ (+ f1.x f2.x) 2)
   (/ (+ f1.y f2.y) 2)])

;; For hooking in
(fn mt.raw-touchpressed
  [id x y]
  (let [partners (std.filter #(< (. $ :time-down) *tap-time*) fingers true)
        partner-id (std.first (or (std.keys partners) [nil]))]
    (tset
     fingers
     id
     {:x x
      :y y
      :partner partner-id
      :time-down 0})
    (when partner-id
      (tset (. fingers partner-id) :partner id))))

(fn mt.raw-touchreleased
  [id x y]
  (let [finger (. fingers id)]
    (cond
      (not (. finger :partner))
      (do
        (if (<= (. finger :time-down) *tap-time*)
          (call-hook mt.tapped x y)
          (call-hook mt.dropped x y))
        (tset fingers id nil))
      :else
      (tset fingers id nil))))

(fn mt.raw-touchmoved
  [id x y dx dy]
  (let [finger (. fingers id)]
    (cond
      (not finger.partner)
      (call-hook mt.dragged x y dx dy)
      (not (. fingers finger.partner))
      nil ;; Broken heart
      :else
      (let [tf finger
            of (. fingers finger.partner)
            prev-distance (distance tf of)
            [prev-mid-x prev-mid-y] (mid tf of)]
        (tset tf :x x)
        (tset tf :y y)
        (let [curr-distance (distance tf of)]
          (if (> (math.abs (- prev-distance curr-distance)) *pinch-threshold*)
            (call-hook mt.pinched (- curr-distance prev-distance))
            (let [[curr-mid-x curr-mid-y] (mid tf of)]
              (call-hook mt.two-finger-drag curr-mid-x curr-mid-y (- curr-mid-x prev-mid-x) (- curr-mid-y prev-mid-y)))))))))

(fn mt.update
  [dt]
  (each [_ finger (pairs fingers)]
    (tset finger :time-down (+ (. finger :time-down) dt))))

mt
