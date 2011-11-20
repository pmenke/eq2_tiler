# This class sets all dimensions and basic layout to the ones for EpicQuest 2.

class EQ2::Tiler::BaseTile < EQ2::Tiler::MapTile
  
  def height
    TILE_BASE_HEIGHT
  end
  
  
  def init_tile_image
    list = Magick::ImageList.new("./resources/tiler/ground-base.png")
    @i = list.first
    @i
  end

end