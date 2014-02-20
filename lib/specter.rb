require 'specter/version'

require 'clap'

require 'specter/file'
require 'specter/spec'
require 'specter/reporter'

class Specter
  class Flunked < StandardError
    def details=(values)
      @details = values
    end

    def details
      @details ||= {}
    end
  end

  class FailedAssert < Flunked; end
  class FailedRefute < Flunked; end
  class MissingException < Flunked; end
  class DifferentException < Flunked; end

  def self.current
    Thread.current[:specter] ||= {}
  end

  def patterns
    @patterns ||= []
  end

  def filenames
    Dir[*patterns]
  end

  def run
    Specter::Reporter.start

    statuses = filenames.map { |filename| Specter::File.new(filename).run }

    Specter::Reporter.finish

    statuses.all?
  end
end

module Kernel
  private

  def spec(description, &block)
    Specter::Spec.new(description, &block).run
  end

  def assert(expression)
    flunk "expected true but got #{expression.inspect}", Specter::FailedAssert unless expression
  end

  def refute(expression)
    flunk "expected false but got #{expression.inspect}", Specter::FailedRefute if expression
  end

  def raises(expected)
    yield

  rescue Exception => exception
    flunk nil, Specter::DifferentException unless exception.kind_of? expected

  ensure
    flunk nil, Specter::MissingException unless exception
  end

  def flunk(message = nil, type = Specter::Flunked, details = {})
    exception = type.new message
    exception.details = details
    exception.set_backtrace [caller[1]]

    raise exception
  end
end
