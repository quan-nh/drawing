Red [
  Author: "Quan"
  Needs: 'View
]

view [
  title "Wizeline Logo"
  base 400x400 white draw [
    pen #E93D44

    fill-pen #E93D44
    circle 200x200 120
    
    fill-pen white
    circle 200x200 100

    fill-pen #E93D44
    shape [
      move 100x200
      line
        100x210 145x210 167x260 183x260 225x160 245x210 300x210
        300x190 255x190 235x140 215x140 175x240 155x190 100x190
    ]
  ]
]
