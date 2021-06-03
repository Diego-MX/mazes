class RecursiveBacktracker
  def on(grid)
    cell = grid.rand_cell
    maze_stack = [cell]
    
    while cell
      unvisitd_neighbors = cell.neighbors.select {|ngbr| ngbr.unvisited?}
      
      if unvisited_neighbors.empty?
        maze_stack.pop
      else
        ngbr = unvisited_neighbors.sample
        cell.link(ngbr)
        maze_stack << ngbr
      end
      
      cell = maze_stack.last
    end
    
    puts grid
    grid
  end
end
