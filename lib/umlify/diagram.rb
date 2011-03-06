module Umlify

  # Creates and store a yUML api string for generating diagram
  # type of @statements: 1..* String
  class Diagram

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
            unless name =~ /-/
              cardinality = if statement.associations[name+'-n']
                              ' '+statement.associations[name+'-n']
                            end
              @statements << "[#{statement.name}]-#{name}#{cardinality}>[#{type}]"
            end
          end
        end

      end
    end

    # Returns the yuml.me uri
    def get_uri
      uri = '/diagram/class/'+@statements.join(", ")
    end
  end
end
