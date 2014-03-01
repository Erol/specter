require 'specter/version'

require 'benchmark'
require 'clap'

require 'specter/file'
require 'specter/scope'
require 'specter/spec'
require 'specter/reporter'

class Specter
  class Flunked < StandardError; end

  class FailedAssert < Flunked; end
  class FailedRefute < Flunked; end
  class MissingException < Flunked; end
  class DifferentException < Flunked; end

  def self.current
    Thread.current[:specter] ||= {scopes: []}
  end

  def self.preserve(binding)
    locals = {}

    vars = binding.send :eval, 'local_variables'
    vars.each do |local|
      locals[local] = binding.send :eval, "Marshal.dump #{local}"
    end

    yield

    locals.each do |local, value|
      binding.send :eval, "#{local} = Marshal.load #{value.inspect}"
    end
  end

  def requires
    @requires ||= []
  end

  def patterns
    @patterns ||= []
  end

  def filenames
    Dir[*patterns]
  end

  def runtimes
    @runtimes
  end

  def run
    Specter.current.store :specter, self

    statuses = []

    Specter::Reporter.start

    @runtimes = Benchmark.measure do
      statuses = filenames.map { |filename| Specter::File.new(filename).run }
    end

    Specter::Reporter.finish

    Specter.current.delete :specter

    statuses.all?
  end
end

module Kernel
  private

  def subject(subject)
    Specter.current.store :subject, subject
  end

  def scope(description = nil, &block)
    Specter::Scope.new(description, &block).run
  end

  def spec(description, &block)
    Specter::Spec.new(description, &block).run
  end

  def assert(*args)
    expression = args.shift

    if args.empty?
      flunk "expected: #{expression.inspect} is true", Specter::FailedAssert unless expression
      return
    end

    predicate = args.shift

    if args.empty?
      flunk "expected: #{expression.inspect} is #{"#{predicate}".gsub(/\?$/, '')}", Specter::FailedAssert unless expression.send predicate
      return
    end

    operands = args

    flunk "expected: #{expression.inspect} #{predicate} #{operands.map(&:inspect).join(', ')}", Specter::FailedAssert unless expression.send predicate, *operands
  end

  def refute(*args)
    expression = args.shift

    if args.empty?
      flunk "expected: #{expression.inspect} is false", Specter::FailedRefute if expression
      return
    end

    predicate = args.shift

    if args.empty?
      flunk "expected: #{expression.inspect} is not #{"#{predicate}".gsub(/\?$/, '')}", Specter::FailedRefute if expression.send predicate
      return
    end

    operands = args

    flunk "expected: not #{expression.inspect} #{predicate} #{operands.map(&:inspect).join(', ')}", Specter::FailedRefute if expression.send predicate, *operands
  end

  def raises(expected, message = nil)
    expected = expected.new message if expected.is_a? Class

    yield

  rescue Exception => exception
  ensure
    flunk "expected: raise #{expected.inspect}, got nothing", Specter::MissingException unless exception
    flunk "expected: raise #{expected.inspect}, got #{exception.inspect}", Specter::DifferentException unless exception.kind_of? expected.class
    flunk "expected: raise #{expected.inspect}, got #{exception.inspect}", Specter::DifferentException if message && message != exception.message
  end

  def flunk(message = nil, type = Specter::Flunked)
    exception = type.new message
    exception.set_backtrace [caller[1]]

    raise exception
  end
end
