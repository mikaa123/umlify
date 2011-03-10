require 'shoulda'
require 'umlify'

class UmlClassTest < Test::Unit::TestCase

  context "UmlClass" do

    setup do
      @class = Umlify::UmlClass.new 'Farm'
      @class.variables = ['ducks', 'some_cows', 'farm_house']
      @class.associations['ducks'] = 'Duck'
    end

    should "delete variables from the @variables array if they exist in association" do
      @class.chomp! []
      assert_equal false, @class.variables.include?('ducks')
    end

    should "create a list of children, given all the types available" do
      foo = Umlify::UmlClass.new "Foo"
      foo.parent = "Umlify"

      bar = Umlify::UmlClass.new "Bar"
      bar.parent = "Umlify"

      umlify = Umlify::UmlClass.new "Umlify"

      classes = [foo, bar, umlify]
      classes.each {|c| c.chomp!(classes)}

      assert umlify.children.include? foo
      assert umlify.children.include? bar
      assert_equal nil, foo.parent
      assert_equal nil, bar.parent
    end

    should "be able to infer types for associations with the variables in @variables" do
      classes = [Umlify::UmlClass.new("Foo"), Umlify::UmlClass.new("Bar")]
      foo_bar = Umlify::UmlClass.new "FooBar"
      foo_bar.variables = ["foo", "bars", "args"]
      classes << foo_bar

      foo_bar.infer_types! classes

      assert_equal 'Foo', foo_bar.associations['foo']
      assert_equal 'Bar', foo_bar.associations['bars']
      assert_equal '*', foo_bar.associations['bars-n']
      assert_equal nil, foo_bar.associations['args']
    end

  end
end

