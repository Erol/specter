class Specter
  class Spec
    def description
      @description
    end

    def block
      @block
    end

    def initialize(description, &block)
      @description = description
      @block = block
    end
  end
end
