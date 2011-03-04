require 'optparse'
require 'net/http'

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
          opts.banner = "Usage: umlify [option] [source-files directory]"
          opts.on("-h", "--help",  "Shows this") do
            puts opts
          end
        end.parse! @args

      else
        puts "umlifying"

        @parser = Parser.new @args

        if classes = @parser.parse_sources!
          @diagram = Diagram.new

          @diagram.create do
            classes.each {|c| add c}
          end

          puts "Downloading the image from yUML, it shouldn't be long."

          image = Net::HTTP.start("yuml.me", 80) do |http|
            http.get(URI.escape(@diagram.get_uri))
          end

          File.open('url.png', 'wb') do |file|
            file << image.body
          end if image

          puts "Saved in uml.png"
        else
          puts "No ruby files in the directory"
        end

      end

    end
  end
end
