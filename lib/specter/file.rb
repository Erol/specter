class Specter
  class File
    def filename
      @filename
    end

    def initialize(filename)
      @filename = filename
    end

    def failed
      @failed ||= []
    end

    def failed?
      failed.any?
    end

    def run
      fork do
        begin
          Specter.current.store :file, self

          load filename

        rescue Exception => exception
          fail exception

        ensure
          Specter.current.delete :file

          exit 1 if failed?
        end
      end
    end

    def fail(exception)
      values = {file: Specter.current[:file]}
      failed << values

      puts exception.inspect
    end
  end
end
