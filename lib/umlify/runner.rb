require 'net/http'
require 'optparse'

module Umlify

  # Class to run to execute umlify. It parses the ruby sources provided
  # and generates and save a uml diagram using yUML API.
  class Runner

    attr_reader :smart_mode, :html_mode

    # Takes as input an array with file names
    def initialize args
      @args = args
      @smart_mode = false
      @html_mode = false
    end

    # Runs the application
    def run
      parse_options

      if @args.empty?
        puts "Usage: umlify [source directory]"
      else
        puts "umlifying"

        @parser = ParserSexp.new @args

        if classes = @parser.parse_sources!
          @diagram = Diagram.new

          if @smart_mode
            classes.each {|c| c.infer_types! classes}
          end

          @diagram.create do
            classes.each {|c| add c}
          end.compute!

          puts "Downloading the image from yUML, it shouldn't be long."

          image = download_image
          save_to_file image

          puts 'http://yuml.me'+@diagram.get_uri
          puts "Saved in uml.png"
        else
          puts "No ruby files in the directory"
        end
      end

    end

    def parse_options
      OptionParser.new do |opts|
        opts.on("-s", "--smart") { @smart_mode = true }
        opts.on("-h", "--html") { @html_mode = true }
      end.parse! @args
    end

    # Downloads the image of the uml diagram from yUML
    def download_image
      Net::HTTP.start("yuml.me", 80) do |http|
        http.get(URI.escape(@diagram.get_uri))
      end
    end

    #Saves the diagram to file
    def save_to_file image
      File.open('uml.png', 'wb') do |file|
        file << image.body
      end if image
    end

  end
end
