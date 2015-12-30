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
	# Using stitcher library in class.
	extend Stitcher

	# Define accessor with variable type(Class).
	stitch_accessor name: String, age: Integer

	# Define "set" method with Argument types.
	# set(String, Integer)
	define_stitch(:set, name: String, age: Integer){
		self.name = name
		self.age  = age
	}

	# Define other "set" method.
	# set(Integer, String)
	define_stitch(:set, age: Integer, name: String){
		# Call set(String, Integer)
		set name, age
	}
	
	def print
		p "name:#{name} age:#{age}"
	end
end

x = X.new
x.name = "homu"
x.age  = 14
# x.age = 14.0		# Error: No match method.

x.set "mami", 15
x.print
# => "name:mami age:15"

x.set 14, "mado"
x.print
# => "name:mado age:14"
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
