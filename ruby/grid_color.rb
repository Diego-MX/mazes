require_relative 'grid'
require 'chunky_png'

class ColorGrid < Grid
  def distances=(dists)
    @distances = dists
    farthest, @max = dists.max
  end

  def background_color_for(cell)
    dist   = @distances[cell] || return nil
    zerone = (@max - dist).to_f / @max
    r = (255 * zerone).round
    g = (127 * zerone).round + 128
    b = (255 * zerone).round
    ChunkyPNG::Color.rgb(r, g, b)
  end
end
