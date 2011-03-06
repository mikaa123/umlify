require 'shoulda'
require 'umlify'

class ParserSexpTest < Test::Unit::TestCase

  context "ParserSexp" do

    setup do
      fixture = ["somefile.rb", "someotherfile.rb"]
      @p = Umlify::ParserSexp.new fixture
    end

    should "respond to parse_sources!"  do
      assert_respond_to @p, :parse_sources!
    end

    should "return nil if no source file in the given directory" do
      parser = Umlify::ParserSexp.new ["not_source", "still_not_source"]
      assert_equal nil, parser.parse_sources!
    end

    should "parse class names" do
      test = <<-END_FILE
      class AClassName
      end
      END_FILE
      assert_equal 'AClassName', @p.parse_file(test)[0].name
    end

    should "parse class name of inherited classes" do
      test = <<-END_FILE
      class AClassName < SuperClass
      end
      END_FILE
      assert_equal 'AClassName', @p.parse_file(test)[0].name
      assert_equal 'SuperClass', @p.parse_file(test)[0].parent
    end

    should "parse instance methods" do
      test = <<-END_FILE
      class Bar
        def initialize
        end

        def foo
        end

        def self.selfish
        end
      end
      END_FILE
      assert_equal 'Bar', @p.parse_file(test)[0].name
      assert_equal ['initialize', 'foo'], @p.parse_file(test)[0].methods
    end

    should "parse instance variables" do
      test = <<-END_FILE
      class Bar
        def foo
          @a_variable = "foo"
          @another_variable = "foo"
          @@class_variable = "foo"
        end

        @a_class_instance_variable = "foo"
      end
      END_FILE
      bar = @p.parse_file(test)[0]
      assert_instance_of Umlify::UmlClass, bar
      assert bar.variables.include? "a_variable"
      assert bar.variables.include? "another_variable"
      assert_equal false, bar.variables.include?('a_class_instance_variable')
      assert_equal false, bar.variables.include?('class_variable')
    end

    should "Create associations when the types are specified" do
      test = <<-END_FILE
      # Describe the class's instance variables like that:
      #
      #    type of @unicorn: Unicorn
      #    type of @quackable: Duck
      #    type of @edible: 1..* Cow
      class Bar

        def foo
          @unicorn = Unicorn.new
          @quackable = Duck.new
          @edible = Cow.new
        end
      end
      END_FILE
      bar = @p.parse_file(test)[0]
      assert_instance_of Umlify::UmlClass, bar
      assert_equal "Unicorn", bar.associations['unicorn']
      assert_equal "Duck", bar.associations['quackable']
      assert_equal "Cow", bar.associations['edible']
      assert_equal "1..*", bar.associations['edible-n']
    end

    should "parse inherited classes" do
      test = <<-END_FILE
        class Bar < Hash

          def initialize
          end

          def save
          end

        end
      END_FILE
      bar = @p.parse_file(test)[0]
      assert_instance_of Umlify::UmlClass, bar
      assert_equal "Hash", bar.parent
    end

    should "parse file with multiple classes" do
      test = <<-END_FILE
        class Bar < Hash
        end

        class Foo
        end
      END_FILE

      classes = @p.parse_file(test)
      assert_equal 2, classes.count
    end

    should "return an array of UmlClasses when the parsing is done" do
      p = Umlify::ParserSexp.new Dir[File.dirname(__FILE__)+'/fixtures/*']
      parsed_classes = p.parse_sources!
      puts "here : #{parsed_classes}"
      assert_equal 3, parsed_classes.count
    end

  end
end

