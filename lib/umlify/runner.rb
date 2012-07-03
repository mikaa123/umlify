require 'net/http'
require 'optparse'

module Umlify

  # Run an instance of Umlify program. Only intended for internal use.
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
        parser_sexp = ParserSexp.new @args

        if classes = parser_sexp.parse_sources!
          @diagram = Diagram.new

          if @smart_mode
            classes.each {|c| c.infer_types! classes}
          end

          @diagram.create do
            classes.each {|c| add c}
          end.compute!

          image = download_image(@diagram.get_uri)
          save_to_file image

          puts 'http://yuml.me'+@diagram.get_uri if @html_mode
          puts "Saved in uml.png."
        else
          puts "No ruby files in the directory."
        end
      end

    end

    def parse_options
      OptionParser.new do |opts|
        opts.on("-s", "--smart") { @smart_mode = true }
        opts.on("-h", "--html") { @html_mode = true }
        opts.on("-v", "--version") { puts VERSION }
      end.parse! @args
    end

    # Downloads the image of the uml diagram from yUML
    def download_image uri
      connection = Net::HTTP
      if ENV["HTTP_PROXY"] != nil 
    	  proxy_host = ENV["HTTP_PROXY"].split(":")[0]
    	  proxy_port = ENV["HTTP_PROXY"].split(":")[1]
    	  proxy_user = ENV["HTTP_PROXY_USER"]
    	  proxy_pass = ENV["HTTP_PROXY_PASS"]
    		connection = Net::HTTP::Proxy(proxy_host, proxy_port, proxy_user, proxy_pass)
    	end
      res = connection.post_form(URI("http://yuml.me/diagram/scruffy/class/"), {"dsl_text"=>@diagram.get_dsl})
      puts res.body
      url = "http://yuml.me/#{res.body.strip()}"
      puts url
      #Net::HTTP.get(URI(url))
      connection.start("yuml.me", 80) do |http|
        http.get(URI.decode("/#{res.body}"))        
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
