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
  
  attr_accessor :name, :operations
  
  # This method evaluates the given block and registers all operations
  # that are to be performed when this map tile is rendered.
  def self.configure(name, base_class=EQ2::Tiler::MapTile, &compose_block)
    tile = base_class.send(:new)
    tile.name = name
    if compose_block != nil
      tile.compose compose_block
    end
    tile
  end
  
  # Creates a new map tile object. Maybe combine this with the configure method?
  def initialize
    @i=nil
    @generate_block=nil
    @operations = Array.new
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
  
  # Init the first and bottom-most image. 
  # This could be omitted.
  def init_tile_image
    list = Magick::ImageList.new("/Users/pmenke/git/eq2_tiler/resources/tiler/overlay-base.png")
    @i = list.first
    @i
  end
  
  # This method pulls in and integrates all information and generates
  # a rmagick image object on this basis.
  # Technically, it iterates the list of operations and performs them
  # on top of the base image.
  def generate_tile()
    @i = do_generate_tile(@i)
  end
  
  # This method performs the actual generation of tiles. It can also be
  # called recursively. It returns the new image.
  def do_generate_tile(image)
    i = image
    puts "GENERATE #{name}: #{i}"
    @operations.each do |operation|
      puts "  ! do_#{operation[:operation]}, #{operation}."
      i = send("do_#{operation[:operation]}", i, operation)
    end
    return i
  end
  
  
  # This method calls generate_tile and creates an image file of the
  # desired type.
  def generate_tile_image(output_path, type = :png)
    generate_tile unless @i.nil?
    @i.write(File.join(output_path, "#{name}.#{type}"))
  end
  
  # Shows the tile image in a new window.
  def display_tile_image
    generate_tile unless @i.nil?
    display_image = @i.scale(8.0)
    display_image.display
  end
  
  # Registers all operations formulated in the tile DSL inside the
  # given block.
  def compose(block)
    block.yield self
  end
  
  # adds a new operation hash to the array of operations.
  def add_operation(new_operation)
    @operations << new_operation
  end
  
  # retrieves the first operation with a given key, or nil.
  def get_operation_by_key(key)
    r = @operations.select{|o| o[:key]==key}
    if r != nil
      return r.first if r.size>0
    end
    return nil
  end

  # registers a new 'colorize' operation.
  def colorize(key, color)
    op = {:operation => :colorize, :key => key, :color => color}
    add_operation op
  end
  
  # adopts all operations from other_tile.
  def adopt(other_tile)
    other_tile.operations.each do |op|
      @operations << op.clone
    end
  end
  
  # registers a new 'overlay image' operation.
  def overlay_image(key, overlay_image, colorize=nil, opacity=0.5)    
    op = {:operation => :overlay_image, :image_path => overlay_image, :key => key}
    unless colorize == nil
        op[:colorize] = colorize
    end
    unless opacity == nil
      op[:opacity] = opacity
    end
    add_operation op
  end
  
  # modifies an existing 'overlay image' operation, e.g., to change the image file,
  # the tint or the opacity.
  def modify_overlay(key, hash)
    op = get_operation_by_key(key)
    unless op.nil?
      op.merge! hash.select{|k,v| [:overlay_image,:colorize,:opacity].include? k}
    end
  end
  
  #def modify_overlay(key, overlay_image=nil, colorize=nil, opacity=nil)
  #  op = get_operation_by_key(key)
  #  unless op.nil?
  #    unless overlay_image == nil
  #      op[:overlay_image] = overlay_image
  #    end
  #    unless colorize == nil
  #      op[:colorize] = colorize
  #    end
  #    unless opacity == nil
  #      op[:opacity] = opacity
  #    end
  #  end
  #end
  
  # registers a new 'set height' operation to enlarge the tile.
  def set_height(height) 
    op = {:operation => :set_height, :height => height}
    add_operation op
  end
  
  # performs a 'colorize' operation on the given image, and based on the given hash.
  def do_colorize(image, hash)
    opc = hash[:opacity]
    i2 = image.colorize(opc, opc, opc, hash[:colorize])
    opcounter = hash[:opacity]
    while opcounter > 0.0
      #i2 = i2.darken(0.25)
      #i2 = i2.contrast(true)
      opcounter -= 0.15
    end
    i2 = i2.modulate 1.0, 1.0+(1.0-1.0*hash[:opacity]), 1.0
    return i2
  end

  # performs a 'overlay image' operation on the given image, and based on the given hash.  
  def do_overlay_image(image, hash)
    #puts "get image"
    #puts "#{hash.inspect}"
    #puts "Image: #{hash[:image_path]}"
    #puts "File exists? #{File.exists?(hash[:image_path])}"
    overlay_i = Magick::ImageList.new(hash[:image_path]).first
    #puts "Do we want to colorize?"
    if hash.has_key? :colorize
      
      #opc = hash[:opacity]
      overlay_i = do_colorize(overlay_i, hash.merge({:opacity=>0.5})) #overlay_i.colorize(opc, opc, opc, hash[:colorize])
    end
    return image.composite(overlay_i, 0, image.rows-overlay_i.rows, Magick::OverCompositeOp)
  end
  
  # performs a 'set height' operation on the given image, and based on the given hash.
  def do_set_height(image, hash)
    i = Magick::Image.new(TILE_WIDTH, hash[:height]) {
      self.background_color = "none"
    }
    i = i.composite(image, 0, hash[:height]-image.rows, Magick::OverCompositeOp)
  end
  
end