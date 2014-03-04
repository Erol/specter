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
      scope = Specter.current[:scopes].last

      prepares = []
      prepares += Specter.current[:prepares]
      prepares += Specter.current[:scopes].map(&:prepares).flatten
      prepares.each do |block|
        if scope
          scope.instance_eval(&block)
        else
          block.call
        end
      end

      Specter.preserve block.binding do
        begin
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

    def pass
      Specter.current[:file].pass
    end

    def fail(exception)
      Specter.current[:file].fail exception
    end
  end
end
