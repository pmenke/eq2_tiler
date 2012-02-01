require 'helper'

class TestGenerateBaseTile < Test::Unit::TestCase
  should "generate a base tile image" do
    EQ2::Eorath::EorathTileMaker.init
    EQ2::Eorath::EorathTileMaker.make_color_map
    EQ2::Eorath::EorathTileMaker.make_grass("ForestGreen", "TEST")
    EQ2::Eorath::EorathTileMaker.make_forest("red", "blue", "yellow", "TEST")
    EQ2::Eorath::EorathTileMaker.make_bushes("red", "ForestGreen", "chartreuse1", "TEST")
  
    [
      ["chartreuse1", "eur"],
      ["PaleGreen4", "pale"],
      ["gold4", "gold"],
      ["burlywood4", "aut"],
      ["turquoise3", "spacy"]
    ].each do |x|
      EQ2::Eorath::EorathTileMaker.make_city(x[0], "black", "NavajoWhite3", "NavajoWhite3", "red", x[1])
      %w{red plum blue yellow orange}.each do |m|
        EQ2::Eorath::EorathTileMaker.make_marker(x[0], m, x[1])
      end
    end
    EQ2::Eorath::EorathTileMaker.build
  end
end