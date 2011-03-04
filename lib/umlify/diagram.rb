module Umlify

  ##
  # Creates and store a yUML api string for generating diagram
  #
  class Diagram

    # Array containing yUML DSL statements
    attr_accessor :statements

    def initialize
      @statements = []
    end

    def create &blk
      instance_eval &blk
    end

    # Adds the given statement to the @diagram array
    # Statement can either be a String or an UmlClass
    def add statement
      # TODO: Add some sort of validation

      @statements << statement if statement.is_a? String
      if statement.is_a? UmlClass

        @statements << statement.to_s

        if statement.parent
          @statements << "[#{statement.parent}]^[#{statement.name}]"
        end

        unless statement.associations.empty?
          statement.associations.each do |name, type|
            @statements << "[#{statement.name}]-#{name}>[#{type}]"
          end
        end

      end
    end

    # Dumps the html of the diagram
    def export
      '<img src="http://yuml.me/diagram/class/'+@statements.join(", ")+'" />'
    end
  end
end
