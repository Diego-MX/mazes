require_relative 'cell'
require 'chunky_png'

class Grid
  attr_reader :rows, :cols

  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @grid = prepare_grid
    configure_cells
  end

  def prepare_grid
    Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new(row, col)
      end
    end
  end
  def [](row, col)
    return nil unless row.between?(0, @rows-1)
    return nil unless col.between?(0, @cols-1)
    @grid[row][col]
  end

  def configure_cells
    each_cell do |cell|
      row, col = cell.row, cell.col
      cell.north = self[row-1, col]
      cell.south = self[row+1, col]
      cell.east  = self[row, col+1]
      cell.west  = self[row, col-1]
    end
  end

  def rand_cell
    r = rand(@rows)
    c = rand(@grid[row].count)
    self[row, col]
  end
  def size
      @rows * @cols
  end
  def each_row
    @grid.each do |row|
      yield row
    end
  end
  def each_cell
    each_row do |row|
      row.each do |cell|
        yield cell if cell
      end
    end
  end


  def contents_of(cell)
      " "
  end
  def background_color_for(cell)
    nil
  end

  def to_s0
    output = "\t+" + "---+"*cols + "\n"

    each_row do |row|
      mid = "\t|"
      btm = "\t+"

      row.each do |cell|
        cell = Cell.new(-1, -1) unless cell
        east_bdry  = (cell.linked?(cell.east ) ? " "  : "|")
        south_bdry = (cell.linked?(cell.south) ? "   ": "---")

        mid << " #{contents_of(cell)} " << east_bdry
        btm << south_bdry << "+"
      end
      output << mid << "\n"
      output << btm << "\n"
    end
    output << "\n\n"
  end

  def to_s1
    # PREPARATION
    hrz = "\u2500"  #  ─
    vrt = "\u2502"  #  │
    crn = "\u2518"  #  ┘
    nswe = ["", "\u2576", "\u2574", "\u2500",   #     ╶  ╴  ─
      "\u2577", "\u250C", "\u2510", "\u252C",   #  ╷  ┌  ┐  ┬
      "\u2575", "\u2514", "\u2518", "\u2534",   #  ╵  └  ┘  ┴
      "\u2502", "\u251C", "\u2524", "\u253C"]   #  │  ├  ┤  ┼

    snew = ["", "\u2574", "\u2576", "\u2500",   #     ╴  ╶  ─
      "\u2575", "\u2514", "\u2518", "\u2534",   #  ╵  ┘  └  ┴
      "\u2577", "\u2510", "\u250C", "\u252C",   #  ╷  ┐  ┌  ┬
      "\u2502", "\u2524", "\u251C", "\u253C"]   #  │  ┤  ├  ┼

    aux_n = Cell.new(-1,-1)
    aux_w = Cell.new(-1,-1)
    aux_d = Cell.new(-1,-1)
    aux_n.link(aux_d)
    aux_w.link(aux_d)

    # CALCULATION
    out = ""
    each_row do |row|
      top = "\t"
      mid = "\t"
      btm = "\t"
      for cell_ in row.each
        cell_n = cell_.north || aux_n
        cell_w = cell_.west  || aux_w
        cell_d = cell_n.west || aux_d

        # Edges referenced about NW corner of cell_
        edge_n = !cell_n.linked?(cell_d)
        edge_s = !cell_w.linked?(cell_)
        edge_w = !cell_w.linked?(cell_d)
        edge_e = !cell_n.linked?(cell_)
        edges = [edge_n, edge_s, edge_w, edge_e]
        key = edges.inject(0){|n, b| 2*n + (b ?1:0)}

        top << nswe[key] + (edge_e ? hrz : " ")*3
        mid << (edge_s ? vrt : " ") + " #{contents_of(cell_)} "

        last_row = (cell_.row == @rows-1)
        if last_row
          # Edges referenced about SW corner of cell_
          edge_n = edge_s
          edge_s = false
          edge_w = !cell_.west.nil?
          edge_e = true
          edges = [edge_n, edge_s, edge_w, edge_e]
          key = edges.inject(0){|n, b| 2*n + (b ?1:0)}

          btm << nswe[key] + hrz*3
        end
      end
      # Edges referenced about NE corner of cell_
      edge_n = !cell_.north.nil?
      edge_s = true
      edge_w = !cell_n.linked?(cell_)
      edge_e = false
      edges = [edge_n, edge_s, edge_w, edge_e]
      key = edges.inject(0){|n, b| 2*n + (b ?1:0)}

      top << nswe[key] + "\n"
      mid << vrt + "\n"
      out << top + mid + (last_row ? btm : "")
    end
    out << crn + "\n\n"
  end

  def to_s
    hrz  =  "\u2500"    #  ─
    vrt  =  "\u2502"    #  │
    crn  =  "\u2518"    #  ┘
    nswe = ["", "\u2576", "\u2574", "\u2500",     #     ╶  ╴  ─
      "\u2577", "\u250C", "\u2510", "\u252C",     #  ╷  ┌  ┐  ┬
      "\u2575", "\u2514", "\u2518", "\u2534",     #  ╵  └  ┘  ┴
      "\u2502", "\u251C", "\u2524", "\u253C"]     #  │  ├  ┤  ┼

    extended = Grid.new(@rows+2, @cols+2)
    # extended[1..@rows+1, 1..@cols+1] = @grid
    for r in 0...@rows
      for c in 0...@cols
        extended[r+1, c+1] = @grid[r,c]
      end
    end
    for r in 0...@rows+2
      cell1 = extended[r, 0]
      cell2 = extended[r, @cols+1]
      if cell1.north
        cell1.link(cell1.north)
        cell2.link(cell2.north)
      end
      if cell1.south
        cell1.link(cell1.south)
        cell2.link(cell2.south)
      end
    end
    for c in 0...@cols+2
      cell1 = extended[0, c]
      cell2 = extended[@rows+1, c]
      if cell1.west
        cell1.link(cell1.west)
        cell2.link(cell2.west)
      end
      if cell1.east
        cell1.link(cell1.east)
        cell2.link(cell2.east)
      end
    end

    out = ""
    for r in 0..@rows do
      top = "\t"
      mid = "\t"
      for c in 0..@cols do
        cell_  = extended[r+1, c+1]
        cell_n = cell_.north
        cell_w = cell_.west
        cell_d = cell_n.west

        # Edges referenced about NW corner of cell_
        edge_n = !cell_n.linked?(cell_d)
        edge_s = !cell_w.linked?(cell_)
        edge_w = !cell_w.linked?(cell_d)
        edge_e = !cell_n.linked?(cell_)
        edges = [edge_n, edge_s, edge_w, edge_e]
        key = edges.inject(0){|n, b| 2*n + (b ?1:0)}

        top << nswe[key] + (edge_e ? hrz : " ")*3
        mid << (edge_s ? vrt : " ") + " #{contents_of(cell_)} "

      end
      top << "\n"
      mid << "\n"
      out << top + mid
    end
    out
  end

  def to_png(cell_len: 10)
    img_width  = cell_len*cols + 1
    img_height = cell_len*rows + 1

    background = ChunkyPNG::Color::WHITE
    wall = ChunkyPNG::Color::BLACK

    img = ChunkyPNG::Image.new(img_width, img_height, background)

    [:backgrounds, :walls].each do |mode|
      each_cell do |cell|
        x1 = cell_len * cell.col
        y1 = cell_len * cell.row
        x2 = x1 + cell_len
        y2 = y1 + cell_len

        if mode == :backgrounds
          color = background_color_for(cell)
          img.rect(x1, y1, x2, y2, color, color) if color
        else
          img.line(x1,y1,x2,y1, wall) unless cell.north
          img.line(x1,y1,x1,y2, wall) unless cell.west
          img.line(x2,y1,x2,y2, wall) unless cell.linked?(cell.east)
          img.line(x1,y2,x2,y2, wall) unless cell.linked?(cell.south)
        end
      end
    end
    return img
  end

end
