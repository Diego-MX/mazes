require_relative 'grid'
require 'pickup'

class AldousBroder

  def self.on_0(grid)
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
    unvisited = Array.new;  grid.each_cell {|cell| unvisited.push(cell)}
    boundaries = Hash.new()

    cell = unvisited.sample
    unvisited.delete(cell)
    until unvisited.empty? do
      candidates = cell.neighbors | [cell]
      candidates.each do |cndte|
        if cndte.borders?(unvisited)
          boundaries[cndte] = 1
        else
          boundaries.delete(cndte)
        end
      end
      boundaries.update(boundaries) {|bndry, _|
        1.0/ 3**(1+cell.manhattan(bndry))}        # Can modify weights here.

      bndry = Pickup.new(boundaries).pick
      bndry_neighbors = bndry.neighbors & unvisited
      nghbr = bndry_neighbors.sample
      bndry.link(nghbr)
      unvisited.delete(nghbr)

      cell = nghbr
    end
    puts grid
    grid
  end
end
