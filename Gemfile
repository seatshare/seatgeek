source :rubygems

gem 'faraday'

group :no_travis do
  RUBY_VERSION =~ /^1\.9/ ? gem('ruby-debug19') : gem('ruby-debug')
end

gemspec
