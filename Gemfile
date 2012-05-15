source 'https://rubygems.org'

gem 'faraday'
gem 'multi_json'
gem 'rake'
gem 'yajl-ruby'

group :test do
  gem 'rspec'
end

group :no_travis do
  gem 'awesome_print'
  RUBY_VERSION =~ /^1\.9/ ? gem('ruby-debug19') : gem('ruby-debug')
end

gemspec
