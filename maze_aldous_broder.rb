class AldousBroder

  def self.on(grid)
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

  def self.on2(grid)
    # Ruby in the learning, for which the code needs some translating.
    require 'pickup'  # Does this need gem pickup on terminal?

    def manhattan(cell1, cell0)
      abs(cell1.row - cell0.row) + abs(cell1.col - cell0.col)
    end

    unvisited = Set.new(grid.each_cell)
    def borders_unvisited?(cell)  # How does this depend on unvisited, dynamically or statically?
      !(cell in unvisited) and any(cell.neighbors in unvisited)
    end

    boundaries = Hash.new()
    cell = unvisited.sample
    cell = unvisited.delete(cell)
    until unvisited.empty? do
      # Examine BOUNDARIES Keys
      candidates = cell.neighbors.join(cell)
      candidates.each do |cndte|
        borders_unvisited?(cndte) ? boundaries.add(cndte => 1): boundaries.delete(cndte)
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
