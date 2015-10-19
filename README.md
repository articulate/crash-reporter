# CrashReporter

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
  c.default_tag = "crashy"   # defaults to 'crash report'
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/crash-reporter.

