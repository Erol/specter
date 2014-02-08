require 'specter/version'

require 'clap'

class Specter
  def patterns
    @patterns ||= []
  end

  def filenames
    Dir[*patterns]
  end
end
