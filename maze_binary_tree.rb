class BinaryTree
  def self.on(grid)
    grid.each_cell do |cell|
      neighbors = []
      neighbors << cell.north if cell.north
      neighbors << cell.east  if cell.east

      index = rand(neighbors.length)
      nghbr = neighbors[index]

      cell.link(nghbr) if nghbr
    end

    grid
  end
end
