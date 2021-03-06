module CrashReporter
  module DSL

    module ClassMethods
      def capture_errors(*methods)
        methods.each do |method_name|
          unbound = self.instance_method(method_name)
          remove_method method_name

          # wrap given method in begin/rescue clause
          define_method method_name do
            begin
              unbound.bind(self).call
            rescue StandardError => e
              CrashReporter.report(e)

              # continue to raise original error
              raise e
            end
          end
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def capture_errors(&block)
      begin
        yield
      rescue StandardError => e
        report_crash(e)

        raise e
      end
    end

    def report_crash(data)
      CrashReporter.report(data)
    end
  end
end
