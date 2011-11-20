# this is a convenience class that contains just a method to generate tiles suitable for 
# the world of Éorath in EpicQuest 2.

class EQ2::Eorath::EorathTileMaker
  
  def self.make
    # todo set up a container and store generated tiles there.
    
    grasstile = EQ2::Tiler::MapTile.generate("grass", EQ2::Tiler::BaseTile) do |tile|
      tile.colorize "green"
      tile.overlay "grasses", "yellow"
    end
    
  end
  
end