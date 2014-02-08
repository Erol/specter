require 'specter/version'

require 'clap'

require 'specter/file'
require 'specter/spec'

class Specter
  class Flunked < StandardError; end
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
    statuses = filenames.map { |filename| Specter::File.new(filename).run }
    statuses.all?
  end
end

module Kernel
  private

  def spec(description, &block)
    Specter::Spec.new(description, &block).run
  end

  def assert(actual)
    flunk actual, Specter::FailedAssert unless actual
  end

  def refute(actual)
    flunk actual, Specter::FailedRefute if actual
  end

  def raises(expected)
    yield

  rescue Exception => exception
    flunk nil, Specter::MissingException unless exception
    flunk nil, Specter::DifferentException unless exception.kind_of? expected
  end

  def flunk(message = nil, type = Specter::Flunked)
    exception = type.new message
    exception.set_backtrace [caller[1]]

    raise exception
  end
end
