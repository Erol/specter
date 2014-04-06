class Specter
  class Spec
    def description
      @_description
    end

    def block
      @_block
    end

    def scopes
      Specter.now.scopes
    end

    def prepares
      scopes.map(&:prepares).flatten
    end

    def initialize(description, &block)
      @_description = description
      @_block = block
    end

    def prepare
      scope = scopes.last

      prepares.each { |block| scope.instance_eval(&block) }
    end

    def run
      prepare

      Specter.preserve block.binding do
        begin
          Specter.now.spec = self

          block.call
          pass

        rescue StandardError => exception
          fail exception

        ensure
          Specter.now.spec = nil
        end
      end
    end

    def pass
      Specter.now.file.pass
    end

    def fail(exception)
      Specter.now.file.fail exception
    end
  end
end
