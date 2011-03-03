require 'shoulda'
require 'umlify'

class ParserTest < Test::Unit::TestCase

  context "Parser" do

    setup do
      fixture = ["somefile.rb", "someotherfile.rb"]
      @p = Umlify::Parser.new fixture
    end

    should "respond to parse_sources!"  do
      assert_respond_to @p, :parse_sources!
    end

    should "return nil if no source file in the given directory" do
      parser = Umlify::Parser.new ["not_source", "still_not_source"]
      assert_equal nil, parser.parse_sources!
    end

    should "parse class names" do
      test = <<-END_FILE
      class AClassName
      end
      END_FILE
      assert_equal 'AClassName', @p.parse_file(test)[0].name
    end

    should "parse @variables in classes" do
      test = <<-END_FILE
      class Bar
        def foo
          @a_variable = "foo"
        end
      end
      END_FILE
      bar = @p.parse_file(test)[0]
      assert_instance_of Umlify::UmlClass, bar
      assert bar.variables.include? "a_variable"
    end

    should "parse attr_accessor when preceeded by a # type: Type annotation" do
      test = <<-END_FILE
      class Bar

        # type: FooBar
        attr_accessor :unicorn

        def foo
        end
      end
      END_FILE
      bar = @p.parse_file(test)[0]
      assert_instance_of Umlify::UmlClass, bar
      assert_equal "FooBar", bar.associations['unicorn']
    end

    should "parse attr_reader when preceeded by a # type: Type annotation" do
      test = <<-END_FILE
      class Bar

        # type: FooBar
        attr_reader :unicorn

        def foo
        end
      end
      END_FILE
      bar = @p.parse_file(test)[0]
      assert_instance_of Umlify::UmlClass, bar
      assert_equal "FooBar", bar.associations['unicorn']
    end


    should "parse attr_writer when preceeded by a # type: Type annotation" do
      test = <<-END_FILE
      class Bar

        # type: FooBar
        attr_writer :unicorn

        def foo
        end
      end
      END_FILE
      bar = @p.parse_file(test)[0]
      assert_instance_of Umlify::UmlClass, bar
      assert_equal "FooBar", bar.associations['unicorn']
    end

    should "return an array of UmlClasses when the parsing is done" do
      p = Umlify::Parser.new Dir[File.dirname(__FILE__)+'/fixtures/*']
      parsed_classes = p.parse_sources!
      puts "here : #{parsed_classes}"
      assert_equal 3, parsed_classes.count
    end

  end
end
