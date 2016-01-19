class RecursiveBacktracker
  def on(grid)
    # unvisited = Array.new; grid.each_cell {|cell| unvisited << cell}
  
    current = grid.rand_cell
    maze_stack = [current]
    # unvisited.delete(current)
    
    while current 
      unvstd_neighbors = current.neighbors.select {|ngbr| !ngbr.links.any?}
      # unvstd_neighbors = current.neighbors & unvisited
      
      ngbr = unvstd_neighbors.sample   # Does .sample return nil when empty?
      if ngbr 
        current.link(ngbr)
        maze_stack << ngbr
        current = ngbr
      else
        maze_stack.pop
        current = maze_stack.last  # Does .last return nil when empty? 
      end
    end
  end

end
