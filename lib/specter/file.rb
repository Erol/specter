class Specter
  class File
    def filename
      @filename
    end

    def initialize(filename)
      @filename = filename
    end

    def passed
      @passed ||= []
    end

    def passed?
      not failed?
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

      Process.wait

      $?.success?
    end

    def pass
      values = {file: Specter.current[:file], spec: Specter.current[:spec]}
      passed << values

      Specter::Reporter.progress values
    end

    def fail(exception)
      values = {file: Specter.current[:file], spec: Specter.current[:spec]}
      failed << values

      Specter::Reporter.progress values
    end
  end
end
