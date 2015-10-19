module CrashReporter
  class Configure
    attr_accessor :engines, :default_tag

    def self.setup(&block)
      config = new
      yield config

      config
    end

    def initialize
      @engines = []
    end

    # clears out all prior added engines
    def engine=(engine)
      @engines = [engine]
    end
  end
end
