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
    c = rand(@grid[r].count)
    self[r, c]
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
    output << "\n"
  end

  def to_s
    # PREPARATION
    hrz0 = " "*3
    hrz1 = "\u2500"*3  #  ───
    vrt0 = " "
    vrt1 = "\u2502"    #  │
    nswe = ["", "\u2576", "\u2574", "\u2500",   #     ╶  ╴  ─
      "\u2577", "\u250C", "\u2510", "\u252C",   #  ╷  ┌  ┐  ┬
      "\u2575", "\u2514", "\u2518", "\u2534",   #  ╵  └  ┘  ┴
      "\u2502", "\u251C", "\u2524", "\u253C"]   #  │  ├  ┤  ┼

    aux_nw = aux_ne = aux_sw = aux_se = Cell.new(-1,-1)
    aux_nw.link(aux_ne)
    aux_ne.link(aux_se)
    aux_se.link(aux_sw)
    aux_sw.link(aux_nw)

    # CALCULATION
    out = ""
    for r in 0..@rows
      top = "\t"
      mid = "\t"
      for c in 0..@cols
        cell_nw = self[r-1, c-1] || aux_nw
        cell_ne = self[r-1, c-0] || aux_ne
        cell_sw = self[r-0, c-1] || aux_sw
        cell_se = self[r-0, c-0] || aux_se

        edge_n = !cell_nw.linked?(cell_ne)
        edge_s = !cell_se.linked?(cell_sw)
        edge_w = !cell_sw.linked?(cell_nw)
        edge_e = !cell_ne.linked?(cell_se)
        edges = [edge_n, edge_s, edge_w, edge_e]
        key = edges.inject(0){|n, b| 2*n + (b ?1 : 0)}

        top << nswe[key] + (edge_e ? hrz1 : hrz0)
        mid << (edge_s ? vrt1 : vrt0) + " #{contents_of(cell_se)} "
      end
      out << top + "\n" + mid + "\n"
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
