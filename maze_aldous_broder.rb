class AldousBroder

  def self.on2(grid)
    cell = grid.rand_cell
    unvstd = grid.size - 1
    while unvstd > 1
      nghbr = cell.neighbors.sample
      if nghbr.links.empty?
        cell.link(nghbr)
        unvstd -= 1
      end
      cell = nghbr
    end
    grid
  end

  def self.on(grid)
    # Ruby in the learning, for which the code needs some translating.
    require 'pickup'  # Does this need gem pickup on terminal?

    def manhattan(cell1, cell0)
      abs(cell1.row - cell0.row) + abs(cell1.col - cell0.col)
    end

    def borders?(cell, outside)
      !(outside.include(cell)) & any? {|other| outside.include(other)}
    end

    unvisited = Set.new
    grid.each_cell {|cell| unvisited.add(cell)}
    boundaries = Hash.new()
    cell = unvisited.sample
    cell = unvisited.delete(cell)
    until unvisited.empty? do
      # Examine BOUNDARIES Keys
      cell_neighbors = cell.neighbors
      candidates = cell_neighbors << cell
      candidates.each do |cndte|
        borders?(cndte, unvisited) ? boundaries.add(cndte => 1) :   boundaries.delete(cndte)
      end
      # Adjust BOUNDARIES Values
      boundaries.each do |bndry|
        boundaries[bndry] = 1/ (1+ manhattan(bndry, cell))
      end
      # Choose CELL from BOUNDARY with weights and its NEIGHBOR.
      bndry = Pickup.new(boundaries).pick   # Is this the best package to sample with weights?
      bndry_neighbors = filter(neighbors in unvisited)
      cell = bndry_neighbors.sample
      unvisited.delete(cell)
    end
    grid
  end
end
