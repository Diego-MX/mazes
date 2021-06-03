require_relative 'grid_color'
require_relative 'maze_aldous_broder'

r = 20
c = 20

6.times do |i|
  file_to = "images/aldous_broder_%02d.png" % i

  grid = ColorGrid.new(r, c)
  AldousBroder.on(grid)

  center_cell = grid[r/2, c/2]
  grid.distances = center_cell.distances

  grid.to_png.save(file_to)
  puts "saved to #{file_to}"
end
