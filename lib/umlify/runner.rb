require 'optparse'

module Umlify

  ###
  # This class is instanciated and run by the bin file
  #
  class Runner

    # Contains the options from the command line
    attr_reader :args

    # type: Parser
    attr_accessor :parser

    # type: Diagram
    attr_accessor :diagram

    # Takes as input an array with the command line options
    def initialize args
      @args = args
    end

    # Runs the application
    def run
      @args.push "-h" if @args.empty?

      if @args[0][0] == '-'

        OptionParser.new do |opts|
          opts.banner = "Usage: umlify [option]"
          opts.on("-h", "--help",  "Shows this") do
            puts opts
          end
        end.parse! @args

      else
        puts "umlifying"
        if files = get_files_from_dir(@args[0])
          puts "about to parse..."
          @parser = Parser.new files

          if classes = @parser.parse_sources!
            @diagram = Diagram.new

            @diagram.create do
              classes.each {|c| add c}
            end

            File.open("uml.html", 'w') do |file|
              file << @diagram.export
            end

            puts "Saved in uml.html"
          else
            puts "No ruby files in the directory"
          end

        else
          puts "empty directory"
        end
      end

    end

    private

    def get_files_from_dir directory
      Dir[directory] unless Dir[directory].empty?
    end
  end
end
