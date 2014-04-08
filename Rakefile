$:.unshift File.join File.dirname(__FILE__), 'lib'

require "specter"

$VERBOSE = true

desc 'Run gem specs'
task :spec do
  specter = Specter.new
  specter.includes << 'spec/*.rb'
  specter.excludes << 'spec/examples/**/*.rb'

  success = specter.run

  exit 1 unless success
end

task :default => :spec
