require 'grid_distance'
require 'mz_binary_tree'

grid = DistanceGrid.new(5,5)
BinaryTree.on(grid)

start = grid[0,0]
distances = start.distances

grid.distances = distances
puts grid

puts "path from NW to SW corner:\n"
grid.distances = distances.path_to(grid[grid.rows-1, 0])
puts grid.to_s