Red [Needs: 'View]

branch-colors: [0.152.212 179.99.5 227.32.23 255.211.0 0.120.42 243.169.187 160.165.169 155.0.86 0.54.136 0.0.0 149.205.186 0.164.167 238.124.14 132.184.23]
commit-radius: 3
init: 10x10
d: 20x20

; git log --all --date-order --pretty="%h|%p|%D|%s"
git-log: read/lines %git-log
commits: []
child-commits: #()
branches: #()
active-branches: [1]
y: 1
graph: [line-width 2]

draw-commit: func [commit hash ref-names children] [
  color: pick branch-colors commit/x
  pos: as-pair init/x + (d/x * (commit/x - 1))
               init/y + (d/y * (commit/y - 1))
  result: reduce [
    'pen color 'fill-pen color
    'circle pos commit-radius
    'text (pos + (as-pair (6 - commit/x) * d/x -5)) hash
    'pen 168.169.169
    'text (pos + (as-pair (9 - commit/x) * d/x -5)) ref-names
  ]

  foreach c children [
    child: select commits c
    color: pick branch-colors max commit/x child/x
    child-pos: as-pair init/x + (d/x * (child/x - 1))
                       init/y + (d/y * (child/y - 1))
    
    repend result ['pen color]

    case [
      commit/x = child/x [
        repend result ['line pos child-pos]
      ]

      commit/x > child/x [
        tmp-pos: as-pair pos/x child-pos/y + d/y
        repend result [
          'line pos tmp-pos
          'curve tmp-pos
                 as-pair tmp-pos/x child-pos/y
                 as-pair child-pos/x tmp-pos/y
                 child-pos
        ]
      ]

      commit/x < child/x [
        tmp-pos: as-pair child-pos/x pos/y - d/y
        repend result [
          'curve pos
                 as-pair pos/x tmp-pos/y
                 as-pair tmp-pos/x pos/y
                 tmp-pos
          'line tmp-pos child-pos
        ]
        remove find active-branches child/x
      ]
    ]
  ]
  
  result
]

calc-x: func [node] [
  x: 0
  if sub-commits: find commits node [
    foreach [_ p] sub-commits [
      x: max x p/x
    ]
  ]
  x: x + 1

  while [find active-branches x] [
    x: x + 1
  ]
  
  x
]

; find the HEAD
foreach log git-log [
  set [commit _ ref-names _] split log #"|"
  if find ref-names "HEAD" [
    put branches commit 1
    break
  ]
]

foreach log git-log [
  set [commit p ref-names msg] split log #"|"
  parents: split p space
  children: any [select child-commits commit []]

  x: select branches commit
  if not x [
    x: calc-x children/1
    put branches commit x
    append active-branches x
  ]

  either px: select branches parents/1 [
    put branches parents/1 min x px
  ] [
    put branches parents/1 x
  ]

  foreach parent parents [
    c: any [select child-commits parent copy []]
    append c commit
    put child-commits parent c  
  ]

  pos: as-pair x y
  put commits commit pos
  append graph draw-commit pos commit ref-names children
  y: y + 1
]

view [
  title "git graph"
  base 800x600 white draw graph
]
