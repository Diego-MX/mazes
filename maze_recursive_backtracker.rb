class RecursiveBacktracker
  def on(grid)
    starter = grid.rand_cell
    maze_stack = [starter]
    
    until maze_stack.empty?
      current = maze_stack.last
      unvisitd_neighbors = current.neighbors.select {|ngbr| !ngbr.links.any?}
      # A cell is unvisited if it has no links.
      
      if !unvisited_neighbors.empty?
        ngbr = unvisited_neighbors.sample
        current.link(ngbr)
        maze_stack << ngbr
      else
        maze_stack.pop
      end
      current = maze_stack.last   # Does .last return nil when empty? 
    end
    
    puts grid
    grid
  end

end
