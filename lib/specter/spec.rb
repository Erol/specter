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
      Specter.current[:prepares].each(&:call)

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
