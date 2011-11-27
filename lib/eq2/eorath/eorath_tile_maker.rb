# this is a convenience class that contains just a method to generate tiles suitable for 
# the world of Éorath in EpicQuest 2.

include EQ2::Tiler

class EQ2::Eorath::EorathTileMaker
  
  
  def self.setup_images
    
    tmp = {
      :noise1 => "ground-noise-1",
      :noise2 => "ground-noise-2",
      :noise1_trans => "ground-noise-transparent-1",
      :grass1 => "grass",
      :grass2 => "grass-high",
      :grass_trans => "grass-transparent",
      :round_bush_shadow1 => "vegetation-round-bush-shadow-1",
      :round_bush1 => "vegetation-round-bush-1",
      :round_bush_flowers1 => "vegetation-round-bush-flowers-1",
      :wheat_straws => "vegetation-wheat-straws",
      :wheat_ears => "vegetation-wheat-ears",
      :forest_treetops => "vegetation-forest-treetops",
      :forest_stems => "vegetation-forest-stems",
      :water1 => "water-1",
      :swamp1 => "puddle-1"
    }
    
    @@images = Hash.new
    
    tmp.each_pair do |k,v|
      @@images[k] = "/Users/pmenke/git/eq2_tiler/resources/tiler/overlay-#{v}.png"
      puts " => /Users/pmenke/git/eq2_tiler/resources/tiler/overlay-#{v}.png"
    end
    
  end
  
  def self.make
    # todo set up a container and store generated tiles there.
    
    self.setup_images
    tiles = Array.new
    
    # create various color collections
    
    greens = %w{SpringGreen2 SpringGreen4 DarkSeaGreen LimeGreen PaleGreen4 ForestGreen chartreuse1 turquoise OliveDrab2 DarkOliveGreen3}
    
    browns = %w{MediumGoldenRod gold4 goldenrod3 NavajoWhite3 burlywood4 DarkOrange4 sienna ivory} # bisque4 salmon4
    
    waters = %w{SlateGray2 SteelBlue DeepSkyBlue CadetBlue2 LightSeaGreen aquamarine3}
    
    beiges = %w{tan2 burlywood goldenrod3 gold2}
    
    violets = %w{plum lavender}
    
    turquoises = %w{SkyBlue turquoise3 aquamarine3}
    
    # first, create atomic base tiles
    
    # ground; noise and general textures
    
    noise1 = MapTile.configure "Noise1" do |tile|
      tile.overlay_image :ground, @@images[:noise1]
    end

    noise2 = MapTile.configure "Noise2" do |tile|
      tile.overlay_image :ground, @@images[:noise2]
    end
    
    water1 = MapTile.configure "Water1" do |tile|
      tile.overlay_image :ground, @@images[:water1]
    end
    
    swamp1 = MapTile.configure "Swamp1" do |tile|
      tile.set_height 19
      tile.overlay_image :ground, @@images[:noise1]
      tile.overlay_image :swamp, @@images[:swamp1]
      tile.overlay_image :grass, @@images[:grass_trans]
    end
        
        
    #tiles << noise1
    #tiles << noise2
    
    # create flat structure tiles
    
    # grasses of different shades
    
    vilt = violets + turquoises
    
    vilt.each do |col|
      tile = MapTile.configure "Grassland-#{col}" do |tile|
        tile.adopt noise1
        tile.modify_overlay :ground, :colorize => col, :opacity => 0.6
        tile.overlay_image :ground2, @@images[:noise1_trans], "DimGray", 0.5
      end
      tiles << tile
    end
    
    
    # create medium high grasses of different shades
    
    vilt.each do |col|
      tile = MapTile.configure "Grassland-Medium-#{col}" do |tile|
        tile.adopt noise1
        tile.set_height 19
        tile.modify_overlay :ground, :colorize => col, :opacity => 0.3
        tile.overlay_image :ground2, @@images[:noise1_trans], "DimGray", 0.5
        tile.overlay_image :grass, @@images[:grass1], col, 0.6
      end
      tiles << tile
    end
    
    # create high grasses of different shades
    vilt.each do |col|
      tile = MapTile.configure "Grassland-High-#{col}" do |tile|
        tile.adopt noise1
        tile.set_height 20
        tile.modify_overlay :ground, :colorize => col, :opacity => 0.3
        tile.overlay_image :ground2, @@images[:noise1_trans], "DimGray", 0.5
        tile.overlay_image :grass, @@images[:grass2], col, 0.6
      end
      tiles << tile
    end    
    
    
    # swamps of different shades
    
    violets.each do |green|
      turquoises.each do |water|
        swampTile = MapTile.configure "Swamp-#{water}-#{green}" do |tile|
          tile.adopt swamp1
          tile.modify_overlay :ground, :colorize => green
          tile.modify_overlay :swamp, :colorize => water
          tile.modify_overlay :grass, :colorize => green
        end
        tiles << swampTile
      end
    end
    
    # vegetation
    
    # create forests of different greens
    
    violets.each do |green|
      turquoises.each do |brown|
        tile = MapTile.configure "Forest-#{green}-over-#{brown}" do |tile|
          tile.adopt noise1
          tile.set_height 21
          tile.modify_overlay :ground, :colorize => "SlateGray", :opacity => 0.3
          tile.overlay_image :stems, @@images[:forest_stems], brown, 0.3
          tile.overlay_image :treetops, @@images[:forest_treetops], green, 0.3
        end
        tiles << tile
      end
    end  
    
    
    round_bush1 = MapTile.configure "RoundBush1" do |tile|
      tile.adopt noise1
      tile.set_height 20
      tile.overlay_image :shadow,  @@images[:round_bush_shadow1]
      tile.overlay_image :bush,    @@images[:round_bush1]
      tile.overlay_image :flowers, @@images[:round_bush_flowers1]
    end
    
    #tiles << round_bush1
    
    # generate various round bushes.
    
    turquoises.each do |ground|
      violets.each do |bush|
        ['GreenYellow', 'RoyalBlue3'].each do |flowers|
          roundBush = MapTile.configure "RoundBush-#{flowers}-on-#{bush}-over-#{ground}" do |tile|
            tile.adopt round_bush1
            tile.modify_overlay :ground, :colorize => ground
            tile.modify_overlay :shadow, :colorize => "#333333"
            tile.modify_overlay :bush, :colorize => bush
            tile.modify_overlay :flowers, :colorize => flowers, :opacity => 0.75
          end
          tiles << roundBush
        end
      end
    end
    
    
    # II. create color-schemed items
    
    
    #[0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8].each do |x|
    #  round_bush1_european = MapTile.configure "RoundBush1European-#{x}" do |tile|
    #    tile.adopt noise1
    #    tile.modify_overlay :ground, {:colorize => "ForestGreen", :opacity => x}
    #    tile.adopt round_bush1
    #    tile.modify_overlay :bush, {:colorize => "DarkGreen", :opacity => x}
    #    tile.modify_overlay :flowers, {:colorize => "Red", :opacity => x}
    #  end
    #  tiles << round_bush1_european
    #end

    wheat_straws = MapTile.configure "WheatStraws" do |tile|
      tile.overlay_image :wheat_straws, @@images[:wheat_straws]
    end
    
    wheat_ears = MapTile.configure "WheatEars" do |tile|
      tile.overlay_image :wheat_ears, @@images[:wheat_ears]
    end

    wheat_field = MapTile.configure "WheatField" do |tile|
      tile.adopt noise1
      tile.set_height 22
      tile.modify_overlay :ground, {:colorize => "DarkGoldenrod4", :opacity => 0.8}
      tile.adopt wheat_straws
      tile.modify_overlay :wheat_straws, {:colorize => "LightGoldenrod", :opacity => 0.6}
      tile.adopt wheat_ears
      tile.modify_overlay :wheat_ears, {:colorize => "gold2", :opacity => 0.6}
    end
    
    #tiles << wheat_field
    
    #base_tile = MapTile.configure "base", MapTile do |tile|
    #  tile.overlay_image :base, @@images[:base]
    #end
    
    #bare_ground_tile = MapTile.configure "bare_ground" do |tile|
    #  tile.adopt base_tile
    #  tile.colorize :ground, "maroon"
    #end
    
    #grass_tile = MapTile.configure "grass" do |tile|
    #  tile.adopt bare_ground_tile
    #  tile.overlay_image :grass, @@images[:grass], "green"
    #end
    
    #high_grass_tile = MapTile.configure "high_grass" do |tile|
    #  tile.adopt bare_ground_tile
    #  tile.set_height 20
    #  tile.overlay_image :stuff, @@images[:horizontal_lines_1], "green", 0.2
    #  tile.overlay_image :grass, @@images[:grass_bundle_1], "green"
    #end
    
    #blue_grass_tile = MapTile.configure "blue_grass" do |tile|
    #  tile.adopt grass_tile
    #  tile.set_height 22
    #  tile.modify_overlay :grass, {:colorize => "blue"}
    #end
    
    #wheat_tile = MapTile.configure "wheat" do |tile|
    #  tile.adopt grass_tile
    #  tile.set_height 22
    #  tile.overlay_image :wheat_straws, @@images[:wheat_straws], "orange", 0.5
    #end
    
    #tiles << bare_ground_tile
    #tiles << grass_tile
    #tiles << high_grass_tile
    #tiles << wheat_tile
    #tiles << blue_grass_tile
    
    tiles.each do |tile|
      tile.generate_tile_image("/Users/pmenke/git/eq2_tiler/output/")
    end
    
  end
  
end