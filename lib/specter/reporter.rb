class Specter
  module Reporter
    module Colors
      DESC = '33'
      PASS = '32'
      FAIL = '31'
      LINE = '34'
    end

    CODE = Hash.new { |h, k| h[k] = ::File.readlines(k) }

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
