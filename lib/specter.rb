require 'specter/version'

require 'clap'

class Specter
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
