filename = __FILE__.tap { |path| path.slice! Dir.pwd + '/' }

puts "Load: #{filename}"
puts "Run: #{filename}" if Specter.current[:file]
