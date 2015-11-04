module CrashReporter
  class Configure
    attr_accessor :engines, :tags, :project_name, :repo_url, :version

    def self.setup(&block)
      config = new
      yield config

      config
    end

    def initialize
      @engines = []
      @tags = ['crash report']
    end

    # clears out all prior added engines
    def engine=(engine)
      @engines = [engine]
    end

    def tags=(*tags)
      @tags = tags
    end

    def project_name
      @project_name || repo_name
    end

    def repo_url
      @repo_url ||= `git config --get remote.origin.url`.chomp
    end

    def repo_path
      repo_url.split('/').last(2).join('/')
    end

    def repo_name
      repo_url.split('/').last
    end

    def version=(version)
      @version = version
      @tags << version
    end
  end
end
