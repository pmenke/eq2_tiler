# this is a convenience class that contains just a method to generate tiles suitable for 
# the world of Éorath in EpicQuest 2.

include EQ2::Tiler

class EQ2::Eorath::EorathTileMaker
  
    # load all relevant basic images and put them into a hash.
    def self.setup_images
      tmp = {
        :noise1 => "ground-noise-1",
        :noise2 => "ground-noise-2",
        :noise3 => "ground-noise-3",
        :noise1_trans => "ground-noise-transparent-1",
        :grass1 => "grass",
        :grass2 => "grass-high",
        :grass_trans => "grass-transparent",
        :round_bush_shadow1 => "vegetation-round-bush-shadow-1",
        :round_bush1 => "vegetation-round-bush-1",
        :round_bush_flowers1 => "vegetation-round-bush-flowers-1",
        :round_bush_fruits1 => "vegetation-round-bush-fruits-1",
        :wheat_straws => "vegetation-wheat-straws",
        :wheat_ears => "vegetation-wheat-ears",
        :forest_treetops => "vegetation-forest-treetops",
        :forest_stems => "vegetation-forest-stems",
        :water1 => "water-1",
        :swamp1 => "puddle-1",
        :cityShad => "City-Shadows",
        :cityWall => "City-Walls",
        :cityHous => "City-House",
        :cityRoof => "City-Roof",
        :marker => "marker",
        :markerpost => "post",
        :markerflag => "flag",
        :mountain => "mountain",
        :mountaintop => "mountaintop"
      }
      @@images = Hash.new
      tmp.each_pair do |k,v|
        @@images[k] = "/Users/pmenke/git/eq2_tiler/resources/tiler/overlay-#{v}.png"
        puts " => /Users/pmenke/git/eq2_tiler/resources/tiler/overlay-#{v}.png"
    end
  end
  
  def self.make_color_map
    f = File.open("/Users/pmenke/colormap.html", "w")
    f << "<html><head><title>Colormap</title></head><body>\n"
    @@colors.collect{|k,v| v}.flatten.each do |color|
      puts color
      puts color.class.name
      p = Magick::Pixel.from_color(color)
      rgb = p.to_color(Magick::AllCompliance,false,8,true)
      f << "<p>\n"
      f << "<span style='color:#{rgb};background-color:#{rgb}'>cccccc</span>\n"
      f << "#{color}\n"
      f << "</p>\n"
    end
    f << "</body></html>\n"
    f.close
  end
  
  # setup all relevant basic colors and put them into a hash.
  def self.setup_colors
    @@colors = Hash.new
    @@colors[:greens]     = %w{SpringGreen2 SpringGreen4 DarkSeaGreen LimeGreen PaleGreen4 ForestGreen chartreuse1 turquoise OliveDrab2 DarkOliveGreen3}
    @@colors[:browns]     = %w{MediumGoldenRod gold4 goldenrod3 NavajoWhite3 burlywood4 DarkOrange4 sienna ivory} # bisque4 salmon4
    @@colors[:waters]     = %w{SlateGray2 SteelBlue DeepSkyBlue CadetBlue2 LightSeaGreen aquamarine3}
    @@colors[:beiges]     = %w{tan2 burlywood goldenrod3 gold2 LightYellow khaki2 LightGoldenrod wheat}
    @@colors[:violets]    = %w{plum lavender}
    @@colors[:turquoises] = %w{SkyBlue turquoise3 aquamarine3}
  end
  
  def self.setup_short_color_names
    @@short_to_long_colors = Hash.new
    
    @@short_to_long_colors[:zz1] = "red"
    @@short_to_long_colors[:zz2] = "blue"
    @@short_to_long_colors[:zz3] = "yellow"
    @@short_to_long_colors[:zz4] = "green"
    @@short_to_long_colors[:zz5] = "white"
    @@short_to_long_colors[:zz6] = "black"
    
    @@short_to_long_colors[:gr1] = "SpringGreen2"
    @@short_to_long_colors[:gr2] = "SpringGreen4"
    @@short_to_long_colors[:gr3] = "DarkSeaGreen"
    @@short_to_long_colors[:gr4] = "LimeGreen"
    @@short_to_long_colors[:gr5] = "PaleGreen4"
    @@short_to_long_colors[:gr6] = "ForestGreen"
    @@short_to_long_colors[:gr7] = "chartreuse1"
    @@short_to_long_colors[:gr8] = "turquoise"
    @@short_to_long_colors[:gr9] = "OliveDrab2"
    @@short_to_long_colors[:grA] = "DarkOliveGreen3"
    
    @@short_to_long_colors[:br1] = "MediumGoldenRod"
    @@short_to_long_colors[:br2] = "gold4"
    @@short_to_long_colors[:br3] = "NavajoWhite3"
    @@short_to_long_colors[:br4] = "burlywood4"
    @@short_to_long_colors[:br5] = "DarkOrange4"
    @@short_to_long_colors[:br6] = "sienna"
    @@short_to_long_colors[:br7] = "ivory"
    
    @@short_to_long_colors[:bl1] = "SlateGray2"
    @@short_to_long_colors[:bl2] = "SteelBlue"
    @@short_to_long_colors[:bl3] = "DeepSkyBlue"
    @@short_to_long_colors[:bl4] = "CadetBlue2"
    @@short_to_long_colors[:bl5] = "LightSeaGreen"
    
    @@short_to_long_colors[:bg1] = "tan2"
    @@short_to_long_colors[:bg2] = "burlywood"
    @@short_to_long_colors[:bg3] = "goldenrod3"
    @@short_to_long_colors[:bg4] = "gold2"
    
    @@short_to_long_colors[:vi1] = "plum"
    @@short_to_long_colors[:vi2] = "lavender"
    
    @@short_to_long_colors[:ye1] = "LightYellow"
    @@short_to_long_colors[:ye2] = "khaki2"
    @@short_to_long_colors[:ye3] = "LightGoldenrod"
    @@short_to_long_colors[:ye4] = "wheat"
    
    @@short_to_long_colors[:tq1] = "SkyBlue"
    @@short_to_long_colors[:tq2] = "turquoise3"
    @@short_to_long_colors[:tq3] = "aquamarine3"
    
    @@long_to_short_colors = @@short_to_long_colors.invert
    
  end

  # define an empty output attribute for output tiles
  def self.setup_output_tiles
    @@output = Hash.new
  end
  
  
  def self.init
    setup_colors
    setup_images
    setup_short_color_names
    define_basic_tiles
    setup_output_tiles
  end
  
  def self.build(path)
    @@output.each do |name,tile|
      tile.generate_tile_image(path)
    end
  end
  
  def self.long_color(short_color)
    @@short_to_long_colors[short_color]
  end
  
  def self.short_color(long_color)
    @@long_to_short_colors[long_color]
  end
  
  # define basic tiles
  
  def self.define_basic_tiles
    @@tiles = Hash.new
    @@tiles[:noise1] = MapTile.configure "Noise1" do |tile|
      tile.overlay_image :ground, @@images[:noise1]
    end
    @@tiles[:noise2] = MapTile.configure "Noise2" do |tile|
      tile.overlay_image :ground, @@images[:noise2]
    end
    @@tiles[:noise3] = MapTile.configure "Noise3" do |tile|
      tile.overlay_image :ground, @@images[:noise3]
    end
    @@tiles[:water1] = MapTile.configure "Water1" do |tile|
      tile.overlay_image :ground, @@images[:water1]
    end
    @@tiles[:swamp1] = MapTile.configure "Swamp1" do |tile|
      tile.set_height 19
      tile.overlay_image :ground, @@images[:noise1]
      tile.overlay_image :swamp, @@images[:swamp1]
      tile.overlay_image :grass, @@images[:grass_trans]
    end
    @@tiles[:round_bush1] = MapTile.configure "RoundBush1" do |tile|
      tile.adopt @@tiles[:noise1]
      tile.set_height 20
      tile.overlay_image :shadow,  @@images[:round_bush_shadow1]
      tile.overlay_image :bush,    @@images[:round_bush1]
      tile.overlay_image :flowers, @@images[:round_bush_flowers1]
    end
    @@tiles[:round_bush2] = MapTile.configure "RoundBush1" do |tile|
      tile.adopt @@tiles[:noise1]
      tile.set_height 20
      tile.overlay_image :shadow, @@images[:round_bush_shadow1]
      tile.overlay_image :bush,   @@images[:round_bush1]
      tile.overlay_image :fruits, @@images[:round_bush_fruits1]
    end
    @@tiles[:city] = MapTile.configure "City" do |tile|
      tile.set_height 24
      tile.overlay_image :ground, @@images[:noise1]
      tile.overlay_image :shadow, @@images[:cityShad]
      tile.overlay_image :wall, @@images[:cityWall]
      tile.overlay_image :house, @@images[:cityHous]
      tile.overlay_image :roof, @@images[:cityRoof]      
    end
    @@tiles[:marker] = MapTile.configure "Marker" do |tile|
      tile.set_height 22
      tile.overlay_image :ground, @@images[:noise2]
      #tile.overlay_image :marker, @@images[:marker]
      tile.overlay_image :post, @@images[:markerpost]
      tile.overlay_image :flag, @@images[:markerflag]
    end
    @@tiles[:mountain] = MapTile.configure "Mountain" do |tile|
      tile.set_height 24
      tile.overlay_image :ground, @@images[:noise1]
      tile.overlay_image :mountain, @@images[:mountain]
      tile.overlay_image :mountaintop, @@images[:mountaintop]
    end
  end
  

  def self.create_ground_tiles(ground_colors)
    # TODO
  end
  
  def self.generate_tile_name(tiletype, color, theme = nil)
    name = "#{tiletype}"
    #if color.kind_of? Array
    #  color.each do |c|
    #    name = name + ("-#{short_color(c)}")
    #  end
    #else
    #  name = name + ("-#{short_color(color)}")
    #end 
    name = "#{name}-#{theme}" unless theme.nil?
    name
  end
  
  def self.make_grass(col, gcol, theme = nil)
    # flat grasses of different shades  
    name = generate_tile_name("GrasLo", [col, gcol], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:noise1]
      tile.modify_overlay :ground, :colorize => col, :opacity => 0.6
      tile.overlay_image :ground2, @@images[:noise1_trans], "DimGray", 0.5
    end
    @@output.store tile.name, tile
    
    # create medium high grasses of different shades
    name = generate_tile_name("GrasMed", [col, gcol], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:noise1]
      tile.set_height 19
      tile.modify_overlay :ground, :colorize => col, :opacity => 0.3
      tile.overlay_image :ground2, @@images[:noise1_trans], "DimGray", 0.5
      tile.overlay_image :grass, @@images[:grass1], gcol, 0.6
    end
    @@output.store tile.name, tile

    # create high grasses of different shades
    name = generate_tile_name("GrasHi", [col, gcol], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:noise1]
      tile.set_height 20
      tile.modify_overlay :ground, :colorize => col, :opacity => 0.3
      tile.overlay_image :ground2, @@images[:noise1_trans], "DimGray", 0.5
      tile.overlay_image :grass, @@images[:grass2], gcol, 0.6
    end
    @@output.store tile.name, tile
  end
  
  def self.make_sand(col, theme = nil)
    # flat grasses of different shades  
    name = generate_tile_name("Sand", col, theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:noise3]
      tile.modify_overlay :ground, :colorize => col, :opacity => 0.8
    end
    @@output.store tile.name, tile
  end
  
  def self.make_swamp(ground, water, grass, theme = nil)
    name = generate_tile_name("Sumpf", [ground,water,grass], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:swamp1]
      tile.modify_overlay :ground, :colorize => ground
      tile.modify_overlay :swamp, :colorize => water
      tile.modify_overlay :grass, :colorize => grass
    end
    @@output.store tile.name, tile
  end
  
  def self.make_water(shallow, theme = nil)
    # flat grasses of different shades  
    name = generate_tile_name("WasserShallow", [shallow], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:water1]
      tile.modify_overlay :ground, :colorize => shallow
    end
    @@output.store tile.name, tile
    
    name = generate_tile_name("WasserDeep", ["SteelBlue"], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:water1]
      tile.modify_overlay :ground, :colorize => "SteelBlue"
    end
    @@output.store tile.name, tile
  end
  
  def self.make_forest(leaf_col, stem_col, ground_col, theme = nil)
    # thick forest  
    name = generate_tile_name("Wald", [leaf_col, stem_col, ground_col], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:noise1]
      tile.set_height 21
      tile.modify_overlay :ground, :colorize => ground_col, :opacity => 0.3
      tile.overlay_image :stems, @@images[:forest_stems], stem_col, 0.3
      tile.overlay_image :treetops, @@images[:forest_treetops], leaf_col, 0.3
    end
    @@output.store tile.name, tile
  end
  
  def self.make_flower_bushes(flower_col, leaf_col, ground_col, theme = nil)
    name = generate_tile_name("Busch", [flower_col, leaf_col, ground_col], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:round_bush1]
      tile.modify_overlay :ground, :colorize => ground_col
      tile.modify_overlay :shadow, :colorize => "#333333"
      tile.modify_overlay :bush, :colorize => leaf_col
      tile.modify_overlay :flowers, :colorize => flower_col, :opacity => 0.75
    end
    @@output.store tile.name, tile
  end
  
  def self.make_fruit_bushes(flower_col, leaf_col, ground_col, theme = nil)
    name = generate_tile_name("Obstbusch", [flower_col, leaf_col, ground_col], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:round_bush2]
      tile.modify_overlay :ground, :colorize => ground_col
      tile.modify_overlay :shadow, :colorize => "#333333"
      tile.modify_overlay :bush,   :colorize => leaf_col
      tile.modify_overlay :fruits, :colorize => flower_col, :opacity => 0.75
    end
    @@output.store tile.name, tile
  end
  
  
  def self.make_city(ground, shadow, wall, house, roof, theme = nil)
    name = generate_tile_name("Stadt", [ground, shadow, wall, house, roof], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:city]
      tile.modify_overlay :ground, :colorize => ground
      tile.modify_overlay :shadow, :colorize => shadow
      tile.modify_overlay :wall,   :colorize => wall
      tile.modify_overlay :house,  :colorize => house
      tile.modify_overlay :roof,   :colorize => roof
    end
    @@output.store tile.name, tile
  end

  def self.make_low_mountain(ground, mountain, theme = nil)
    name = generate_tile_name("Berg-Lo", [ground, mountain], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:mountain]
      tile.modify_overlay :ground, :colorize => ground
      tile.modify_overlay :mountain, :colorize => mountain
      tile.modify_overlay :mountaintop,   :colorize => mountain
    end
    @@output.store tile.name, tile
  end
  
  def self.make_high_mountain(ground, mountain, mountaintop, theme = nil)
    name = generate_tile_name("Berg-Hi", [ground, mountain, mountaintop], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:mountain]
      tile.modify_overlay :ground, :colorize => ground
      tile.modify_overlay :mountain, :colorize => mountain
      tile.modify_overlay :mountaintop,   :colorize => mountaintop
    end
    @@output.store tile.name, tile
  end
  
  
  def self.make_marker(var, ground, post, flag, theme = nil)
    name = generate_tile_name("Marker-#{var}", [ground, post, flag], theme)
    tile = MapTile.configure name do |tile|
      tile.adopt @@tiles[:marker]
      tile.modify_overlay :ground, :colorize => ground
      tile.modify_overlay :post, :colorize => post
      tile.modify_overlay :flag, :colorize => flag
    end
    @@output.store tile.name, tile
  end
  
  
end