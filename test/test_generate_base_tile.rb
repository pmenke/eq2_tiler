require 'helper'

class TestGenerateBaseTile < Test::Unit::TestCase
  should "generate a base tile image" do
    
    EQ2::Eorath::EorathTileMaker.make
    
  end
end