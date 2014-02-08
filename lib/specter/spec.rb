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

    def run
      Specter.current.store :spec, self

      block.call
      pass

    rescue StandardError => exception
      fail exception

    ensure
      Specter.current.delete :spec
    end
  end
end
