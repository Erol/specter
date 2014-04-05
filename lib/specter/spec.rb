class Specter
  class Spec
    def description
      @_description
    end

    def block
      @_block
    end

    def scopes
      Specter.current[:scopes]
    end

    def prepares
      Specter.current[:prepares] + scopes.map(&:prepares).flatten
    end

    def initialize(description, &block)
      @_description = description
      @_block = block
    end

    def prepare
      scope = scopes.last

      prepares.each { |block| scope ? scope.instance_eval(&block) : block.call }
    end

    def run
      prepare

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
