class Specter
  class Scope
    def description
      @description
    end

    def block
      @block
    end

    def initialize(description = nil, &block)
      @description = description
      @block = block
    end

    def run
      Specter.scopes.push self

      Specter.preserve block.binding do
        instance_eval(&block)
      end

      Specter.scopes.pop
    end
  end
end
