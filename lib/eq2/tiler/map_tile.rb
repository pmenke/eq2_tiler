# A map tile is a kind of recipe that tells how to render a game map tile 
# based on information about terrain, vegetation, and special objects that
# are present on that tile. 
#
# Map tile objects are orgenized in a hierarchical structure. If a parent
# tile is present, its properties will be used first, then further
# modifications of the current object.
#
# Map tiles are defined with a special DSL.

class EQ2::Tiler::MapTile
  
  # For EpicQuest 2, the tile width is fixed to 24px.
  TILE_WIDTH=24
  
  # For EpicQuest 2, the minimum tile height is fixed to 18px.
  # However, for certain terrains and vegetations (hills, forests), 
  # tiles usually have an additional height of up to 6px (circa).
  TILE_BASE_HEIGHT=18
  
  attr_accessor :name
  
  def self.generate(name, base_class=EQ2::Tiler::MapTile, &compose_block)
    tile = base_class.send(:new)
    tile.name = name
    tile.compose compose_block
    tile
  end
  
  def initialize
    @i=nil
    @generate_block=nil
    @children = Array.new
    init_tile_image
  end
  
  # The geographical height of the current tile. Useful when you
  # want to determine the sparseness of trees, or whether snow
  # should be rendered on a mountain top.
  def terrain_height
  end
  
  # The actual width of the current tile. Defaults to TILE_WIDTH.
  def width
    TILE_WIDTH
  end
  
  # The actual height of the current tile. Defaults to TILE_HEIGHT.
  def height
    TILE_BASE_HEIGHT
  end
  
  def init_tile_image
    @i = Magick::Image.new(width,height) { self.background_color = "blue" }
    @i
  end
  
  # This method pulls in and integrates all information and generates
  # a rmagick image object on this basis.
  def generate_tile
    # TODO is this still necessary?
    # override this in subclasses
    #compose @generate_block
  end
  
  # This method calls generate_tile and creates an image file of the
  # desired type.
  def generate_tile_image(type = :png)
    generate_tile unless @i.nil?
    @i.write("image.#{type}")
  end
  
  def display_tile_image
    generate_tile unless @i.nil?
    display_image = @i.scale(8.0)
    display_image.display
  end
  
  # returns true iff this MapTile has one or more child MapTiles.
  def has_children?
    @children.size>0
  end
  
  # retrieve all children of this MapTile
  def children
    @children
  end
  
  def compose(block)
    puts "self: #{self}, #{self.class.name}"
    block.yield self
  end
  
  def colorize(color)
    @i = @i.colorize(0.25, 0.25, 0.25, color)
  end
  
  def overlay(overlay_image, colorize=nil, opacity=0.5)
    puts "What this method does: overlay the image '#{overlay_image}' with an opacity of #{opacity}."
    overlay = Magick::ImageList.new("./resources/tiler/overlay-grass.png").first
    unless colorize.nil?
      overlay = overlay.colorize(0.5, 0.5, 0.5, colorize)
    end
    @i = @i.composite(overlay, 0, 0, Magick::OverCompositeOp)
  end
  
end