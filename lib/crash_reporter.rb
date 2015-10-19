require 'crash_reporter/version'
require 'crash_reporter/configure'

module CrashReporter
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configure.new
    end

    def reset
      @configuration = Configure.new
    end

    def report(data)
      configuration.engines.each do |engine|
        engine.run(data)
      end
    end

    def configure(&block)
      yield configuration
    end
  end
end
