module Umlify

  ##
  # Parser is responsible for parsing ruby source files and building an array
  # of uml classes
  #
  class Parser

    # An array containing all the parsed classes
    # type: UmlClass
    attr_accessor :classes

    # files should be an array containing file names with the correct path
    def initialize files
      @files = files
      @classes = []
    end

    # Parses the source code of the files in @files
    # to build uml classes. Returns an array containing all the
    # parsed classes or nil if no ruby file were found in the
    # @files array.
    def parse_sources!

      @source_files = @files.select {|f| f.match /\.rb/}
      return nil if @source_files.empty?

      @source_files.each do |file|
        puts "processing #{file}..."
        f = File.open file, 'r'
        (parse_file f).each {|c| @classes << c}
        f.close
      end

      @classes
    end

    # Parse the given file or string, and return the parsed classes
    def parse_file file
      classes_in_file = []
      current_class = nil
      type_annotation = nil

      file.each do |line|

        # This parses the classes
        line.match(/^\s*class ([\w]*)\b[\s]*$/) do |m|
          current_class = UmlClass.new m[1]
          classes_in_file << current_class
        end

        # This parses the classes and its parent (class Foo < Bar)
        line.match(/^\s*class ([\w]*) < ([\w]*)\b/) do |m|
          current_class = UmlClass.new m[1]
          current_class.parent = m[2]
          classes_in_file << current_class
        end

        if current_class

          # This parses the @variables
          line.match(/@([\w]*)\b/) do |m|
            current_class.variables << m[1] unless current_class.variables.include? m[1]
          end

          # This parses the methods
          line.match(/def ([\w]*)\b/) do |m|
            current_class.methods << m[1] unless current_class.methods.include? m[1]
          end

          # This raises the type_annotation flag
          line.match(/# type: ([\w]*)\b/) {|m| type_annotation = m[1]}

          # This adds an association to the current class, using the type_annotation
          # if type_annotation has been set
          line.match(/(attr_accessor|attr_reader|attr_writer) :([\w]*)\b/) do |m|
            current_class.associations[m[2]] = type_annotation
            type_annotation = nil
          end if type_annotation

        end
      end

      classes_in_file
    end
  end
end
