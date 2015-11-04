# CrashReporter

A meta-tool to enable crash info collection from our toolset without manual effort required from users.

CrashReporter will allow you to build out crash report collection and reporting procedures in response to a failure of some kind within a given project. This is made more for cli tools. Included behaviors allow GitHub issues to be created on errors raised. Additional reporters can be built and included in the workflow as required.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crash-reporter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crash-reporter

## Usage

```ruby
# explicitly require desired reporters
require 'crash_reporter/reporters/github_issues'

CrashReporter.setup do |c|
  c.engine = CrashReporter::GithubIssues.new('username/repo', 'auth_token')
  c.tags = "crashy"   # defaults to 'crash report'
end
```

Note that the repo name can actually be auto-discovered from the local git repo as long as you have a proper `origin` remote setup.

```ruby
class MyCoolClass
  include CrashReporter::DSL

  def method_that_could_crash
    raise StandardError
  end

  # this has to be _after_ all the methods you wish to capture as we redefine the methods to include error capturing
  capture_errors :method_that_could_crash
end

MyCoolClass.new.method_that_could_crash

# Will submit a GitHub issue to your repo and re-raise error!
```

Alternatively, you can handle the error submission yourself without the class-level error handling capture (possibly a more explicit method):

```ruby
class MyCoolClass
  include CrashReporter::DSL

  ARealBadThing = Class.new(StandardError)

  def method_that_could_crash
    capture_errors do
      raise ARealBadThing
    end
  end

  # or

  def will_crash
    begin
      raise StandardError, "Nope!"
    rescue StandardError => e
      report_crash e   # or any raw string message you want
    end
  end
end
```

You can additionally define your own reporters. All these reporters require is a `run` method that takes a string or an object derived from Ruby's `StandardError`. `StandardError` is the recommended method as it allows us to collect backtrace information from the crash in a uniform manner.

```ruby
class SlackReporter
  def initialize(hook_url)
    @hook_url = hook_url
   end

  def run(error)
    HTTP.post(@hook_url,
      json: {
        text: "WE GOT PROBLEMS: #{error.message}"
      })
  end
end
```

Then register your new reporter:

```ruby
# Register a new webhook and use the URL here

CrashReporter.configuration.engines << SlackReporter.new('https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX')
```

Then crashes will push notifications to Slack as well! Note you can stack notifications by `<<` them to the `engines` array. You can clear these by setting `CrashReporter.configuration.engine = SlackReporter.new(...)` which will add the single reporter.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/crash-reporter.

## License

This software is provided under the the [MIT license](LICENSE).
