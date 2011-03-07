require 'shoulda'
require 'umlify'

class UmlClassTest < Test::Unit::TestCase

  context "UmlClass" do

    setup do
      @class = Umlify::UmlClass.new 'Farm'
      @class.variables = ['ducks', 'some_cows', 'farm_house']
      @class.associations['ducks'] = 'Duck'
    end

    should "delete variables from the @variables array if they exist in association"  do
      @class.chomp!
      assert_equal false, @class.variables.include?('ducks')
    end

  end
end

