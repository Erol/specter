class Specter
  module Reporter
    COLORS = [
      PASS = '32',
      FAIL = '31'
    ]

    def self.progress(values)
      filename = values[:file].filename
      description = values[:spec] && values[:spec].description

      if exception = values[:exception]
        puts "#{colorize(FAIL, 'FAILED')} #{description || filename}"
        puts "  #{exception.class}: #{exception.message}"
      else
        puts "#{colorize(PASS, 'PASSED')} #{description}"
      end
    end

    def self.colorize(color, text)
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
