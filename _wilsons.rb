require_relative 'maze_wilsons'
require_relative 'grid_color'

filename = "images/wilsons.png"
r, c = 20, 20

grid = ColorGrid.new(r, c)
Wilsons.on(grid)

center = grid[r/2, r/2]
grid.distances = center.distances

grid.to_png.save(filename)
puts "saved to #{filename}"
