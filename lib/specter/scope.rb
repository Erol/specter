class Specter
  class Scope
    def description
      @description
    end

    def block
      @block
    end

    def prepares
      @prepares ||= []
    end

    def initialize(description = nil, &block)
      @description = description
      @block = block
    end

    def run
      Specter.current[:scopes].push self

      Specter.preserve block.binding do
        instance_eval(&block)
      end

      Specter.current[:scopes].pop
    end
  end
end
