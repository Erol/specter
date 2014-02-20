require "bundler/gem_tasks"

require "specter"

$VERBOSE = true

desc 'Run gem specs'
task :spec do
  specter = Specter.new
  specter.patterns << 'spec/*.rb'
  specter.run
end

task :default => :spec
