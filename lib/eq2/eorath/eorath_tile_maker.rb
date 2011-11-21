# this is a convenience class that contains just a method to generate tiles suitable for 
# the world of Éorath in EpicQuest 2.

include EQ2::Tiler

class EQ2::Eorath::EorathTileMaker
  
  
  def self.setup_images
    
    tmp = {
      :horizontal_lines_1 => "horizontal-lines-1",
      :grass_bundle_1 => "grass-bundle-1",
      :grass => "grass",
      :wheat_straws => "wheat-straws",
      :base => "base"
    }
    
    @@images = Hash.new
    
    tmp.each_pair do |k,v|
      @@images[k] = "/Users/pmenke/git/eq2_tiler/resources/tiler/overlay-#{v}.png"
    end
    
  end
  
  def self.make
    # todo set up a container and store generated tiles there.
    
    self.setup_images
    
    base_tile = MapTile.configure "base", MapTile do |tile|
      tile.overlay_image :base, @@images[:base]
    end
    
    bare_ground_tile = MapTile.configure "bare_ground" do |tile|
      tile.adopt base_tile
      tile.colorize :ground, "maroon"
    end
    
    grass_tile = MapTile.configure "grass" do |tile|
      tile.adopt bare_ground_tile
      tile.overlay_image :grass, @@images[:grass], "green"
    end
    
    high_grass_tile = MapTile.configure "high_grass" do |tile|
      tile.adopt bare_ground_tile
      tile.set_height 20
      tile.overlay_image :stuff, @@images[:horizontal_lines_1], "green", 0.2
      tile.overlay_image :grass, @@images[:grass_bundle_1], "green"
    end
    
    blue_grass_tile = MapTile.configure "blue_grass" do |tile|
      tile.adopt grass_tile
      tile.set_height 22
      tile.modify_overlay :grass, nil, "blue", nil
    end
    
    wheat_tile = MapTile.configure "wheat" do |tile|
      tile.adopt grass_tile
      tile.set_height 22
      tile.overlay_image :wheat_straws, @@images[:wheat_straws], "orange", 0.5
    end
    
    tiles = Array.new
    tiles << bare_ground_tile
    tiles << grass_tile
    tiles << high_grass_tile
    tiles << wheat_tile
    tiles << blue_grass_tile
    
    tiles.each do |tile|
      tile.generate_tile_image("/Users/pmenke/git/eq2_tiler/test/")
    end
    
  end
  
end