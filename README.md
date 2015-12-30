# Stitcher

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/stitcher`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stitcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stitcher

## Usage

```ruby
require "stitcher"

class X
	extend Stitcher

	def initialize value
		@value = value
	end
	# Register method argument types.
	stitcher_register :initialize, [Fixnum]

	# Define multi methods.
	def plus a
		@value + a
	end
	stitcher_register :plus, [Fixnum]

	def plus a
		@value + a.to_i
	end
	stitcher_register :plus, [String]
end

x = X.new 10
# x = X.new "10"		# Error: No match method.

# Call X#plus(Fixnum)
p x.plus -3
# => 7

# Call X#plus(String)
p x.plus "42"
# => 57
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/osyo-manga/gem-stitcher )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
