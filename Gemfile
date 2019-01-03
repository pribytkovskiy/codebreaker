source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'i18n'

group :development do
  gem 'fasterer', '~> 0.4.1'
  gem 'overcommit'
  gem 'rubocop', '~> 0.60.0'
end

group :test do
  gem 'simplecov', require: false
  gem 'rspec'
  gem 'rubocop-rspec'
  gem 'ffaker'
end

group :development, :test do
  gem 'pry'
end
