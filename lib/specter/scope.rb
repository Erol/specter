class Specter
  class Scope
    def description
      @_description
    end

    def block
      @_block
    end

    def prepares
      @_prepares ||= []
    end

    def initialize(description = nil, &block)
      @_description = description
      @_block = block
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
