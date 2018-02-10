# GitlabStatus

A simple utility for performing health & response time checks of the GitLab website

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlab_status'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitlab_status

## CLI Usage

Simply run `gitlab_status check`. This will perform a GET request to 'https://about.gitlab.com' every 10 seconds for a minute, and then print out the average response time from libcurl (typhoeus).

## Ideas

What might be worth looking into is some actual deterministic testing of the response time reporting feature, currently skipped with `xcontext` in `health_check_spec.rb`. Another thing possibly interesting is the bias generated by the first request, which is noticably longer than the others (since it has to initiate a connection). At first, I thought to just skip the first probe during average time counting, but I'm still not feeling sure about it. Feel free to comment and/or send pull requests.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle exec rspec spec` to run the class tests, you can as well run `bundle exec cucumber features` to run the (currently basic) cucumber tests of the CLI. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skycocker/gitlab_status.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
