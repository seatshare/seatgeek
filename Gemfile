source 'https://rubygems.org'

gem 'faraday'

group :no_travis do
  gem 'awesome_print'
  RUBY_VERSION =~ /^1\.9/ ? gem('ruby-debug19') : gem('ruby-debug')
end

gemspec
