Red [Needs: 'View]

branch-colors: [0.152.212 179.99.5 227.32.23 255.211.0 0.120.42 243.169.187 160.165.169 155.0.86 0.54.136 0.0.0 149.205.186 0.164.167 238.124.14 132.184.23]
ref-names-color: 168.169.169
commit-radius: 3
init: 10x10
d: 20x20

commits: []          ; list of commit & its position
child-commits: #()   ; key-value: commit & its children
branches: #()        ; key-value: commit & its branch
active-branches: [1] ; list active branches, HEAD branch is the first one

draw-commit: func [commit ref-names children] [
  node: select commits commit
  color: pick branch-colors node/x
  pos: as-pair init/x + (d/x * (node/x - 1))
               init/y + (d/y * (node/y - 1))
  ; draw commit              
  result: reduce [
    'pen color 'fill-pen color
    'circle pos commit-radius
    'text (pos + (as-pair (6 - node/x) * d/x -5)) commit
    'pen ref-names-color
    'text (pos + (as-pair (9 - node/x) * d/x -5)) ref-names
  ]

  ; draw line between commit & its children
  foreach c children [
    child: select commits c
    color: pick branch-colors max node/x child/x
    child-pos: as-pair init/x + (d/x * (child/x - 1))
                       init/y + (d/y * (child/y - 1))
    
    repend result ['pen color]
    case [
      ; * child
      ; |
      ; * commit
      node/x = child/x [
        repend result ['line pos child-pos]
      ]

      ; * child
      ; |\
      ; | * commit  
      node/x > child/x [
        tmp-pos: as-pair pos/x child-pos/y + d/y
        repend result [
          'line pos tmp-pos
          'curve tmp-pos
                 as-pair tmp-pos/x child-pos/y
                 as-pair child-pos/x tmp-pos/y
                 child-pos
        ]
      ]

      ; | * child
      ; |/
      ; * commit
      node/x < child/x [
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

calc-x: func [
  {* commit
   |\
   * *
   |  \
   |   * x?}
  commit] [
  x: 0
  if sub-commits: find commits commit [
    foreach [_ pos] sub-commits [
      x: max x pos/x
    ]
  ]
  x: x + 1

  ; skip active branches to prevent conflict
  while [find active-branches x] [x: x + 1]
  
  x
]

; git log --all --date-order --pretty="%h|%p|%D|%s"
git-log: read/lines %git-log
; find the HEAD & set it as first branch
foreach log git-log [
  set [commit _ ref-names _] split log #"|"
  if find ref-names "HEAD ->" [
    put branches commit 1
    break
  ]
]

graph: [line-width 2]
y: 1
foreach log git-log [
  set [commit p ref-names msg] split log #"|"
  parents: split p space
  children: any [select child-commits commit []]

  ; get the x position of commit
  x: select branches commit
  if not x [
    x: calc-x children/1
    put branches commit x
    append active-branches x
  ]

  ; update first parent's position based on posision of this commit
  either px: select branches parents/1 [
    put branches parents/1 min x px
  ] [
    put branches parents/1 x
  ]

  ; update child-commits data
  foreach parent parents [
    c: any [select child-commits parent copy []]
    append c commit
    put child-commits parent c
  ]

  ; update commits position
  put commits commit as-pair x y
  ; draw commit
  append graph draw-commit commit ref-names children
  y: y + 1
]

view [
  title "git graph"
  base 800x600 white draw graph
]
