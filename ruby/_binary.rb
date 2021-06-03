require_relative 'grid'
require_relative 'maze_binary_tree'

grid = Grid.new(6, 6)
BinaryTree.on(grid)
puts grid
