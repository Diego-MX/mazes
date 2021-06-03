class HuntAndKill

  def self.on(grid)
    unvisited = Array.new;
    grid.each_cell {|cell| unvisited << cell}

    cell = unvisited.sample
    boundaries = [cell]
    unvisited.delete(cell)

    until unvisited.empty? do
      bndry = boundaries.sample
      unvisited_neighbors = bndry.neighbors & unvisited

      until unvisited_neighbors.empty?
        cell = unvisited_neighbors.sample
        bndry.link(cell)
        unvisited.delete(cell)

        check_up = cell.neighbors | [cell]
        check_up.each do |chck|
          if chck.borders?(unvisited)
            boundaries.push(chck)
          else
            boundaries.delete(chck)
          end
        end

        bndry = cell
        unvisited_neighbors = bndry.neighbors & unvisited
      end
    end
    puts grid
    grid
  end

    # until unvisited.empty? do
      # candidates = cell.neighbors | [cell]
      # candidates.each do |cndte|
      #   if cndte.borders?(unvisited)
      #     boundaries[cndte] = 1
      #   else
      #     boundaries.delete(cndte)
      #   end
      # end
      # boundaries.update(boundaries) {|bndry, _|
      #   1.0/ 3**(1+cell.manhattan(bndry))}        # Can modify weights here.
      #
      # bndry = Pickup.new(boundaries).pick
      # bndry_neighbors = bndry.neighbors & unvisited
      # nghbr = bndry_neighbors.sample
      # bndry.link(nghbr)
      # unvisited.delete(nghbr)
      #
      # cell = nghbr
    # end
  #   puts grid
  #   grid
  # end

end
