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
    Thread.current[:specter] ||= {}
  end

  def self.scopes
    current[:scopes] ||= []
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

  def scope(description = nil, &block)
    Specter::Scope.new(description, &block).run
  end

  def spec(description, &block)
    Specter::Spec.new(description, &block).run
  end

  def assert(expression)
    flunk "expected true but got #{expression.inspect}", Specter::FailedAssert unless expression
  end

  def refute(expression)
    flunk "expected false but got #{expression.inspect}", Specter::FailedRefute if expression
  end

  def raises(expected, message = nil)
    yield

  rescue Exception => exception
  ensure
    flunk "expected #{expected} but nothing was raised", Specter::MissingException unless exception
    flunk "expected #{expected} but #{exception.inspect} was raised", Specter::DifferentException unless exception.kind_of? expected
    flunk "expected '#{message}' but got '#{exception.message}'", Specter::DifferentException if message && message != exception.message
  end

  def flunk(message = nil, type = Specter::Flunked)
    exception = type.new message
    exception.set_backtrace [caller[1]]

    raise exception
  end
end
