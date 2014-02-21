class Specter
  module Reporter
    module Colors
      DESC = '33'
      PASS = '32'
      FAIL = '31'
      LINE = '34'
    end

    CODE = Hash.new { |h, k| h[k] = ::File.readlines(k) }

    def self.start
    end

    def self.finish
      times = Specter.current[:specter].runtimes

      puts
      puts
      puts "Finished in #{"%0.02f" % times.total} seconds"
    end

    def self.dot(text)
      print text
      STDOUT.flush
    end

    def self.progress(values)
      description = values[:spec] && values[:spec].description

      if exception = values[:exception]
        dot colorize Colors::FAIL, 'F'

        puts
        puts
        puts colorize Colors::DESC, description
        puts "  #{colorize Colors::FAIL, code(exception.backtrace)}"
        puts "  #{colorize Colors::FAIL, exception.message}"
        puts "# #{colorize Colors::LINE, exception.backtrace}"
        puts
      else
        dot colorize Colors::PASS, '.'
      end
    end

    def self.colorize(color, text)
      text = text.join("\n") if text.is_a? Array

      "\e[#{color}m#{text}\e[0m"
    end

    def self.code(backtrace)
      begin
        filename, line = backtrace.first.split(':')
        CODE[filename][line.to_i - 1].strip
      rescue
        'N/A'
      end
    end
  end
end
