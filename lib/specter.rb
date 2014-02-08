require 'specter/version'

require 'clap'

require 'specter/file'
require 'specter/spec'

class Specter
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
