class Specter
  module Reporter
    module Colors
      DESC = '33'
      PASS = '32'
      FAIL = '91'
      LINE = '34'
    end

    SEPARATOR = "\u2b80"

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
      if exception = values[:exception]
        description = []
        description << colorize('37;44', " #{values[:subject]} ") + colorize('34;43', SEPARATOR) if values[:subject]
        description << colorize('37;43', " #{values[:scopes].map(&:description).join(" \u2022 ")} ") + colorize('33;41', SEPARATOR) unless values[:scopes].empty?
        description << colorize('37;41', " #{values[:spec].description} " ) + colorize('31;49', SEPARATOR) if values[:spec]
        description << colorize('37;41', " #{exception.class} ") + colorize('31;49', SEPARATOR) if description.empty?
        description = description.join

        puts
        puts
        puts colorize Colors::DESC, description
        puts
        puts "  #{colorize Colors::FAIL, code(exception.backtrace)}"
        puts "  #{colorize Colors::FAIL, exception.message}"
        puts
        puts "#{colorize Colors::LINE, exception.backtrace.first}"
        puts
      else
        dot colorize Colors::PASS, "\u2022"
      end
    end

    def self.colorize(color, text)
      text = text.join("\n") if text.is_a? Array

      "\e[#{color}m#{text}\e[0m"
    end

    def self.code(backtrace)
      begin
        filename, line = backtrace.first.split(':')
        "#{CODE[filename][line.to_i - 1].strip}"
      rescue
        'N/A'
      end
    end
  end
end
