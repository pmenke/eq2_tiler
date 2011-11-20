# A tile bundle is a collection of related tiles, mainly providing convenience methods
# for generating, packaging or testing that collection as a whole.

class EQ2::Tiler::TileBundle
  
  # TODO provide methods for storing selections of tiles, optionally with their
  # descendants.
  
  def initialize
    @tile_collection = Hash.new
  end
  
  def tile_collection
    @tile_collection
  end
  
  def add_tile(new_tile)
    @tile_collection << new_tile
  end
  
  # adds a new MapTile object, along with all its descendants.
  def add_tile_with_descendants(new_tile)
    @tile_collection << new_tile
    new_tile.children.each do |child|
      add_tile_with_descendants(child)
    end
  end
  
  
end