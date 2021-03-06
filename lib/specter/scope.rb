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
      Specter.now.scopes.push self

      instance_eval(&block)

      Specter.now.scopes.pop
    end
  end
end
