#lang racket/gui

(define branch-colors (vector (make-color 0 152 212) (make-color 179 99 5) (make-color 227 32 23) (make-color 255 211 0)))

(define (draw-graph dc)
  (send dc set-brush (vector-ref branch-colors 0) 'solid)
  (send dc set-pen (vector-ref branch-colors 0) 2 'solid)
  (send dc draw-ellipse 10 10 5 5)
  (send dc draw-text "b9ac4e4 [dev]" 90 5)

  (send dc set-brush (vector-ref branch-colors 1) 'solid)
  (send dc set-pen (vector-ref branch-colors 1) 2 'solid)
  (send dc draw-ellipse 30 30 5 5)
  (send dc draw-line 10 10 30 30)
  (send dc draw-text "1d20353 [initial-config]" 90 25)

  (send dc set-brush (vector-ref branch-colors 0) 'solid)
  (send dc set-pen (vector-ref branch-colors 0) 2 'solid)
  (send dc draw-ellipse 10 50 5 5)
  (send dc draw-line 10 10 10 50)
  (send dc draw-text "c37d4fc" 90 45)

  (send dc set-brush (vector-ref branch-colors 1) 'solid)
  (send dc set-pen (vector-ref branch-colors 1) 2 'solid)
  (send dc draw-ellipse 30 70 5 5)
  (send dc draw-line 30 30 30 70)
  (send dc draw-text "e8b0556" 90 65)

  (send dc set-brush (vector-ref branch-colors 0) 'solid)
  (send dc set-pen (vector-ref branch-colors 0) 2 'solid)
  (send dc draw-ellipse 10 90 5 5)
  (send dc draw-line 10 50 10 90)
  (send dc draw-text "bbc6e25" 90 85)

  (send dc set-brush (vector-ref branch-colors 0) 'solid)
  (send dc set-pen (vector-ref branch-colors 0) 2 'solid)
  (send dc draw-ellipse 10 110 5 5)
  (send dc draw-line 10 90 10 110)
  (send dc draw-text "06689bf" 90 105)

  (send dc set-brush (vector-ref branch-colors 2) 'solid)
  (send dc set-pen (vector-ref branch-colors 2) 2 'solid)
  (send dc draw-ellipse 50 130 5 5)
  (send dc draw-line 10 110 50 130)
  (send dc draw-text "584bd51" 90 125)

  (send dc set-brush (vector-ref branch-colors 3) 'solid)
  (send dc set-pen (vector-ref branch-colors 3) 2 'solid)
  (send dc draw-ellipse 70 150 5 5)
  (send dc draw-line 10 90 70 110)
  (send dc draw-line 70 110 70 150)
  (send dc draw-text "dbb4d3c" 90 145)

  (send dc set-brush (vector-ref branch-colors 1) 'solid)
  (send dc set-pen (vector-ref branch-colors 1) 2 'solid)
  (send dc draw-ellipse 30 170 5 5)
  (send dc draw-line 30 30 30 170)
  (send dc set-pen (vector-ref branch-colors 3) 2 'solid)
  (send dc draw-line 70 150 30 170)
  (send dc draw-text "ad8bf4e" 90 165)

  (send dc set-brush (vector-ref branch-colors 0) 'solid)
  (send dc set-pen (vector-ref branch-colors 0) 2 'solid)
  (send dc draw-ellipse 10 190 5 5)
  (send dc draw-line 10 110 10 190)
  (send dc set-pen (vector-ref branch-colors 1) 2 'solid)
  (send dc draw-line 30 170 10 190)
  (send dc set-pen (vector-ref branch-colors 2) 2 'solid)
  (send dc draw-line 50 130 50 170)
  (send dc draw-line 50 170 10 190)
  (send dc draw-text "947b867" 90 185))

(define frame (new frame%
                   [label "git graph"]
                   [width 300][height 200]
                   [x 300][y 300]))
(define a-canvas
  (new canvas% [parent frame]
               [style	'(hscroll vscroll)]
               [paint-callback
                (lambda (canvas dc)
                  (draw-graph dc))]))

(send a-canvas init-auto-scrollbars	200 200 0.0 0.0)

(send frame show #t)
