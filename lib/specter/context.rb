class Specter
  class Context
    def initialize(attributes = {})
      @_attributes = {}

      attributes.each { |k, v| @_attributes[k] = v }
    end

    def method_missing(method, *args, &block)
      attr = String method

      setter = Regexp.new '=$'

      if setter.match attr
        attr.gsub! setter, ''

        @_attributes[:"#{attr}"] = args.shift
      else
        @_attributes[:"#{attr}"]
      end
    end

    def respond_to_missing?(method, private = false)
      @_attributes.include?(method) || super
    end
  end
end
