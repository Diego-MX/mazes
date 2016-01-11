require 'grid_color'
require 'mz_binary_tree'

grid = ColorGrid.new(25,25)
BinaryTree.on(grid)

start = grid[grid.rows/2, grid.cols/2]

grid.distances = start.distances

filename = "images/colorized.png"
grid.to_png.save(filename)
puts "saved to #{filename}"