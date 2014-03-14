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
    Thread.current[:specter] ||= {scopes: [], prepares: []}
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
    @_requires ||= []
  end

  def excludes
    @_excludes ||= []
  end

  def includes
    @_includes ||= []
  end

  def filenames
    Dir[*includes] - Dir[*excludes] - requires
  end

  def runtimes
    @_runtimes
  end

  def run
    Specter.current.store :specter, self

    requires.each do |filename|
      require ::File.join Dir.pwd, filename
    end

    statuses = []

    Specter::Reporter.start

    @_runtimes = Benchmark.measure do
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

  def prepare(&block)
    prepares = if scope = Specter.current[:scopes].last
      scope.prepares
    else
      Specter.current[:prepares]
    end
    prepares.push block
  end

  def assert(*args)
    expect true, *args
  end

  def refute(*args)
    expect false, *args
  end

  def expect(*args)
    expected = args.shift
    type = expected ? Specter::FailedAssert : Specter::FailedRefute
    expression = args.shift
    backtrace = caller[0]
    backtrace = caller[1] if backtrace =~ /`assert'|`refute'/

    if args.empty?
      flunk "expected #{expected}: #{expression.inspect}", type, backtrace if !!expected ^ !!expression
      return
    end

    predicate = args.shift

    if args.empty?
      flunk "expected #{expected}: #{expression.inspect} is #{"#{predicate}".gsub(/\?$/, '')}", type, backtrace if !!expected ^ !!expression.send(predicate)
      return
    end

    operands = args

    flunk "expected #{expected}: #{expression.inspect} #{predicate} #{operands.map(&:inspect).join(', ')}", type, backtrace if !!expected ^ !!expression.send(predicate, *operands)
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

  def flunk(message = nil, type = Specter::Flunked, backtrace = nil)
    exception = type.new message
    exception.set_backtrace [backtrace || caller[1]]

    raise exception
  end
end
