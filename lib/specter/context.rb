class Specter
  class Context
    def initialize(attributes = {})
      @_attributes = {}

      attributes.each { |k, v| @_attributes[k] = v }
    end

    def method_missing(method, *args, &block)
      @_attributes[method]
    end

    def respond_to_missing?(method, private = false)
      @_attributes.include?(method) || super
    end
  end
end
