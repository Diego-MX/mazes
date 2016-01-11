require_relative 'distances'

class Cell
    attr_reader :row, :col
    attr_accessor :north, :south, :east, :west

    def initialize(row, col)
      @row, @col = row, col
      @links = {}
    end
    def to_s
      "<Cell object at (#{@row}, #{@col})>"
    end


    def link(other, bidi=true)
      @links[other] = true
      other.link(self, false) if bidi
      self
    end
    def unlink(other, bidi=true)
      @links.delete[other]
      other.unlink(self, false) if bidi
      self
    end
    def links
      @links.keys
    end
    def linked?(other)
      @links.key?(other)
    end

    def neighbors
      list = []
      list << north if north
      list << south if south
      list << east  if east
      list << west  if west
      return list
    end


    def distances
      dstncs = Distances.new(self)
      bndry = [self]

      while bndry.any?
        new_bndry = []

        bndry.each do |cell_|
          cell_.links.each do |linked|
            next if dstncs[linked]
            dstncs[linked] = dstncs[cell_] + 1
            new_bndry << linked
          end
        end

        bndry = new_bndry
      end
      return dstncs
    end

end
