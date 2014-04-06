class Specter
  class Spec
    def description
      @_description
    end

    def block
      @_block
    end

    def initialize(description, &block)
      @_description = description
      @_block = block
    end

    def prepare
      prepares = Specter.now.scopes.map(&:prepares).flatten
      prepares.each { |block| instance_eval(&block) }
    end

    def run
      prepare

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

    def pass
      Specter.now.file.pass
    end

    def fail(exception)
      Specter.now.file.fail exception
    end
  end
end
