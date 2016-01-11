class Distances

  def initialize(root)
    @root  = root
    @cells = {}
    @cells[@root] = 0
  end


  def [](cell)
    @cells[cell]
  end


  def []=(cell, dist)
    @cells[cell] = dist
  end


  def cells
    @cells.keys
  end


  def path_to(goal)
    current = goal

    breadcrumbs = Distances.new(@root)
    breadcrumbs[current] = @cells[current]

    until current == @root
      # current = min(current.links, key=lambda lk:@cells[lk])
      current.links.each do |nghbr|
        if @cells[nghbr] < @cells[current]
          breadcrumbs[nghbr] = @cells[nghbr]
          current = nghbr
          break
        end
      end
    end

    breadcrumbs
  end


  def max
    max_cell, max_dist = @root, 0

    @cells.each do |cell, distance|
      if distance > max_dist
        max_cell, max_dist = cell, distance
      end
    end

    [max_cell, max_dist]
  end

end
