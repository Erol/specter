class Specter
  class File
    def name
      @_name
    end

    def initialize(name)
      @_name = name
    end

    def passed
      @_passed ||= []
    end

    def passed?
      not failed?
    end

    def failed
      @_failed ||= []
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
      values = {file: Specter.now.file, subject: Specter.now.subject, scopes: Specter.now.scopes, spec: Specter.now.spec}
      passed << values

      Specter::Reporter.progress values
    end

    def fail(exception)
      values = {file: Specter.now.file, subject: Specter.now.subject, scopes: Specter.now.scopes, spec: Specter.now.spec, exception: exception}
      failed << values

      Specter::Reporter.progress values
    end
  end
end
