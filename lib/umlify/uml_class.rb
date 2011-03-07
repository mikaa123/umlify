module Umlify

  # Represents a parsed uml class
  class UmlClass
    attr_accessor :name, :variables, :methods, :associations, :parent

    def initialize name
      @name = name
      @variables = []
      @methods = []
      @associations = {}
    end

    # Deletes variables from the @variables array if they appear
    # in an association
    def chomp!
      @variables = @variables - @associations.keys unless @associations.nil?
    end

    def to_s
      '['+@name+'|'+
      @variables.collect{|var| var}.join(";")+'|'+
      @methods.collect{|met| met}.join(";")+']'
    end
  end
end

