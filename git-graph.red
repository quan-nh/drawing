Red [Needs: 'View]

branch-colors: [0.152.212 179.99.5 227.32.23 255.211.0 0.120.42 243.169.187 160.165.169 155.0.86 0.54.136 0.0.0 149.205.186 0.164.167 238.124.14 132.184.23]
commit-radius: 5
step: 20

draw-commit: func [commit hash children] [
  color: pick branch-colors commit/x
  pos: as-pair 10 + (step * (commit/x - 1))
               10 + (step * (commit/y - 1))
  result: reduce [
    'pen color 'fill-pen color
    'circle pos commit-radius
    'text (pos + (as-pair (5 - commit/x) * step -5)) hash
  ]

  foreach child children [
    color: pick branch-colors max commit/x child/x
    child-pos: as-pair 10 + (step * (child/x - 1))
                        10 + (step * (child/y - 1))
    
    repend result ['pen color]

    case [
      commit/x = child/x [
        repend result ['line pos child-pos]
      ]

      commit/x > child/x [
        tmp-pos: as-pair pos/x child-pos/y + step
        repend result [
          'line pos tmp-pos
          'curve tmp-pos
                 as-pair tmp-pos/x child-pos/y
                 as-pair child-pos/x tmp-pos/y
                 child-pos
        ]
      ]

      commit/x < child/x [
        tmp-pos: as-pair child-pos/x pos/y - step
        repend result [
          'curve pos
                 as-pair pos/x tmp-pos/y
                 as-pair tmp-pos/x pos/y
                 tmp-pos
          'line tmp-pos child-pos
        ]
      ]
    ]
  ]
  
  result
]

graph: [line-width 2]
append graph draw-commit 1x1 "b9ac4e4 [dev]" []
append graph draw-commit 2x2 "1d20353 [initial-config]" [1x1]
append graph draw-commit 1x3 "c37d4fc" [1x1]
append graph draw-commit 2x4 "e8b0556" [2x2]
append graph draw-commit 1x5 "bbc6e25" [1x3]
append graph draw-commit 1x6 "06689bf" [1x5]
append graph draw-commit 3x7 "584bd51" [1x6]
append graph draw-commit 4x8 "dbb4d3c" [1x5]
append graph draw-commit 2x9 "ad8bf4e" [2x4 4x8]
append graph draw-commit 1x10 "947b867" [1x6 3x7 2x9]
append graph draw-commit 2x11 "dad99e7" [1x10]
append graph draw-commit 1x12 "2481939" [1x10 2x11]
append graph draw-commit 2x13 "9ee0123" [1x12]
append graph draw-commit 2x14 "e4bff64" [2x13]

view [
  title "git graph"
  base 300x300 white draw graph
]
