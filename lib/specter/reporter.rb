class Specter
  module Reporter
    module Colors
      DESC = '33'
      PASS = '32'
      FAIL = '91'
      LINE = '34'

      SUBJECT = [37, 100]
      SCOPE = [37, 43]
      SPEC = [37, 41]
      DEFAULT = [39, 49]
    end

    SEPARATOR = "\u2b80"
    DOT = "\u2022"

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
        subject = values[:subject]
        scope = values[:scopes].map(&:description).join(" #{DOT} ")
        spec = if values[:spec]
                 values[:spec].description
               else
                 exception.class
               end

        puts
        puts
        puts powerline subject, Colors::SUBJECT, scope, Colors::SCOPE, spec, Colors::SPEC
        puts
        puts "  #{colorize Colors::FAIL, code(exception.backtrace)}"
        puts "  #{colorize Colors::FAIL, exception.message}"
        puts
        puts "#{colorize Colors::LINE, exception.backtrace.first}"
        puts
      else
        dot colorize Colors::PASS, DOT
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

    def self.powerline(*args)
      string = ''

      background = nil

      until args.empty? do
        text = String args.shift
        colors = args.shift

        next if text.empty?

        if background
          string += colorize("#{background - 10};#{colors.last}", SEPARATOR)
        end

        string += colorize(colors.join(';'), " #{text} ")

        background = colors.last
      end

      if background
        string += colorize("#{background - 10};49", SEPARATOR)
      end

      string
    end
  end
end
