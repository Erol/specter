class Specter
  class Scope
    def description
      @description
    end

    def block
      @block
    end

    def initialize(description = nil, &block)
      @description = description
      @block = block
    end

    def run
      Specter.scopes.push self

      locals = {}

      vars = block.binding.send :eval, 'local_variables'
      vars.each do |local|
        locals[local] = block.binding.send :eval, "Marshal.dump #{local}"
      end

      instance_eval(&block)

      locals.each do |local, value|
        block.binding.send :eval, "#{local} = Marshal.load #{value.inspect}"
      end

      Specter.scopes.pop
    end
  end
end
