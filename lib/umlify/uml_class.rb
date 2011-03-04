module Umlify

  ##
  # Represent a parsed uml class
  #
  class UmlClass
    attr_accessor :name, :variables, :methods, :associations, :parent

    def initialize name
      @name = name
      @variables = []
      @methods = []
      @associations = {}
    end

    def to_s
      '['+@name+'|'+
      @variables.collect{|var| var}.join(";")+'|'+
      @methods.collect{|met| met}.join(";")+']'
    end
  end
end

