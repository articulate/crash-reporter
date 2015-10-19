require 'http'

module CrashReporter
  class GithubIssues
    GH_URI = 'https://api.github.com'

    def initialize(repo_name = CrashReporter.configuration.repo_path, token)
      @repo_name = repo_name
      @token = token
    end

    def run(data)
      # Run custom formatting on Ruby StandardError objects, otherwise, just pass through
      data = format(data) if data.is_a?(StandardError)

      HTTP.headers(
          accept: 'application/vnd.github.v3+json',
          authorization: "token #{@token}"
      ).post("#{GH_URI}/repos/#{@repo_name}/issues", json: {
          labels: [CrashReporter.configuration.default_tag],
          title: "Crash report from #{CrashReporter.configuration.project_name}",
          body: data
      })

      data
    end

    private

    def format(error)
      <<-ERROR
**Error:** #{error.message}

**Backtrace:**
```
#{error.backtrace.join("\n")}
```
ERROR
    end
  end
end
