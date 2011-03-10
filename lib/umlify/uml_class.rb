module Umlify

  # Represents a parsed uml class
  class UmlClass
    attr_accessor :name, :variables, :methods, :associations, :parent, :children

    def initialize name
      @name = name
      @variables = []
      @methods = []
      @associations = {}
    end

    # Deletes variables from the @variables array if they appear
    # in an association.
    # Sets the @children variable
    def chomp! classes
      @variables = @variables - @associations.keys unless @associations.nil?
      @children = classes.select do |c|
        if c.parent == @name
          c.parent = nil
          true
        end
      end
    end

    # Tries to create an association with the attributes in @variables.
    def infer_types! classes
      class_names = classes.collect {|c| c.name}
      @variables.each do |attribute|

        if class_names.include? attribute.classify
          # A type has match with the attribute's name
          @associations[attribute] = attribute.classify

          # If it's a plural, adds a cardinality
          if attribute == attribute.pluralize
            @associations[attribute+'-n'] = '*'
          end
        end
      end
      chomp! classes
    end

    def to_s
      '['+@name+'|'+
      @variables.collect{|var| var}.join(";")+'|'+
      @methods.collect{|met| met}.join(";")+']'
    end
  end
end

