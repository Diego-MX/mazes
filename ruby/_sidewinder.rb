require 'grid'
require 'maze_sidewinder'

grid = Grid.new(6, 6)
Sidewinder.on(grid)
puts grid

puts grid.to_s0
# img = grid.to_png
# img.save "images/sidewinder.png"
