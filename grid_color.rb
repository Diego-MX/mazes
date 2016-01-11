require_relative 'grid'
require 'chunky_png'

class ColorGrid < Grid
  def distances=(distances)
    @distances = distances
    farthest, @max = distances.max
  end

  def background_color_for(cell)
    dist = @distances[cell] or return nil
    intensity = (@max - dist).to_f / @max
    dark = (255 * intensity).round
    bright = 128 + (127 * intensity).round
    ChunkyPNG::Color.rgb(dark, bright, dark)
  end
end
