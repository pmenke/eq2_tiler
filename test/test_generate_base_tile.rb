require 'helper'

class TestGenerateBaseTile < Test::Unit::TestCase
  should "generate a base tile image" do
    basetile = EQ2::Tiler::BaseTile.new
    #basetile.display_tile_image
  end
end