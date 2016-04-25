[![Build Status](https://travis-ci.org/jakeonrails/annotate_gemfile.svg?branch=master)](https://travis-ci.org/jakeonrails/annotate_gemfile)

# AnnotateGemfile

This tool will hit the API at Rubygems and get a description for each gem listed in your project's Gemfile, and add that description as a comment above that gem.

For example, it will turn this Gemfile:

```ruby
source 'https://rubygems.org'

gem 'rails'
gem 'devise'
gem 'marco-polo'

```

Into this Gemfile (saved as Gemfile.annotated):

```ruby
source 'https://rubygems.org'

# Ruby on Rails is a full-stack web framework optimized for programmer happiness
# and sustainable productivity. It encourages beautiful code by favoring
# convention over configuration. (http://github.com/rails/rails)
gem 'rails', '~> 3.2.22'


# Flexible authentication solution for Rails with Warden
# (http://github.com/plataformatec/devise)
gem 'devise', '~> 2.2' # upgrade to 3.x too complicated

# MarcoPolo shows your app name and environment in your console prompt so you
# don't accidentally break production
gem 'marco-polo'

```

## Installation

First install the gem:

    $ gem install annotate_gemfile

## Usage

Inside a Ruby project directory with a Gemfile, execute:

    $ annotate-gemfile

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jakeonrails/annotate_gemfile.
