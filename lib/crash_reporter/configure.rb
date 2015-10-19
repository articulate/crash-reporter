require 'rugged'

module CrashReporter
  class Configure
    attr_accessor :engines, :default_tag, :project_name, :repo

    def self.setup(&block)
      config = new
      yield config

      config
    end

    def initialize
      @engines = []

      @repo = Rugged::Repository.discover('.')
    end

    # clears out all prior added engines
    def engine=(engine)
      @engines = [engine]
    end

    def default_tag
      @default_tag || 'crash report'
    end

    def project_name
      @project_name || repo_name
    end

    def repo_url
      repo.remotes['origin'].url
    end

    def repo_path
      repo_url.split('/').last(2).join('/')
    end

    def repo_name
      repo_url.split('/').last
    end
  end
end
