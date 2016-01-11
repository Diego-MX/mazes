require_relative 'grid_distance'
require_relative 'maze_sidewinder'

grid = DistanceGrid.new(6,6)
Sidewinder.on(grid)

start = grid[0, 0]

distances = start.distances
new_start, dist = distances.max

new_distances = new_start.distances
goal, dist = new_distances.max

grid.distances = new_distances.path_to(goal)
puts grid
