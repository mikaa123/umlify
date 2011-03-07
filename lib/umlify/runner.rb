require 'net/http'

module Umlify

  # Class to run to execute umlify. It parses the ruby sources provided
  # and generates and save a uml diagram using yUML API.
  #
  #  * type of @diagram: Diagram
  #  * type of @args: 0..* String
  #  * type of @parser: ParserSexp
  #
  class Runner

    # Takes as input an array with file names
    def initialize args
      @args = args
    end

    # Runs the application
    def run

      if @args.empty?
        puts "Usage: umlify [source directory]"
      else
        puts "umlifying"

        @parser = ParserSexp.new @args

        if classes = @parser.parse_sources!
          @diagram = Diagram.new

          @diagram.create do
            classes.each {|c| add c}
          end

          puts "Downloading the image from yUML, it shouldn't be long."

          image = download_image
          save_to_file image

          puts @diagram.get_uri
          puts "Saved in uml.png"
        else
          puts "No ruby files in the directory"
        end
      end

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
