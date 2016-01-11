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
  
end