# Differ

Differ is easy to use, micro-gem, for get diff info between text files
TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'differ', :git => 'git://github.com/Nikita-gritsyuk/differ.git'
```

And then execute:

    $ bundle


## Usage

Its realy easy:
```ruby
differ = Diff.new("file1.txt", "file2.txt")

puts differ.to_color_log
puts differ.to_a
puts differ.to_json

puts differ.set_diff_files(file2,file3)
puts differ.to_color_log
puts differ.to_a
puts differ.to_json
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/differ.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

