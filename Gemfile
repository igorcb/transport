source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#gem 'rails', '4.0.3'
#gem 'rails', '4.0.13'
#gem 'rails', '4.2.8'
#gem 'rails', '5.0.6'
gem 'rails', '~> 5.1.6'
gem 'pg', '~> 0.21.0'
gem 'puma', '~> 3.7'
gem 'rails-i18n', '~> 5.1' # For 5.0.x, 5.1.x and 5.2.x

gem 'apexcharts'
gem 'groupdate'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'awesome_nested_fields'
gem "paperclip"
gem 'bootstrap-sass'
gem 'bootstrap-addons-rails'
gem 'will_paginate-bootstrap'
gem 'bootstrap-tagsinput-rails'

gem 'devise'
gem 'ransack'
gem "watir-rails"
#gem 'cancan'
gem 'cancancan' #, github: 'piedoom/cancancan', branch: 'rails5.0'
gem 'rolify'
gem 'cocoon'
gem 'rmagick'
gem "mini_magick"
gem 'rtesseract'
#gem 'cocaine' to tarrapin
gem 'terrapin'
# #gem 'cep', '~> 0.0.8'
gem 'correios-cep'
gem 'ruby-json'
gem 'odf-report'
#gem 'odf-ods-report'
gem 'business_time'
gem 'extensobr'
gem 'ranked-model'
gem 'roxml'
gem 'ruby-nfe', '~> 0.0.4'
gem 'thinreports'
gem 'thinreports-rails'
# #
gem 'barby'
gem 'chunky_png'
# #
#gem "cpf_cnpj"
gem 'migration_data'
# #
gem 'apartment'
gem 'enumerize'
gem 'time_difference'
# #
gem 'rubocop'
gem 'autoprefixer-rails', '~> 8.2'
gem 'geocoder'

gem 'prawn'
gem 'prawn-table'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'sidekiq', '~> 5.2', '>= 5.2.3'
gem 'sidekiq-scheduler', '~> 3.0'

gem 'redis'
gem 'simple_token_authentication', '~> 1.0' # see semver.org


group :test do
  gem 'database_cleaner'
  # gem "factory_bot_rails"
  # gem "ffaker"
  gem 'rspec-sidekiq'
  gem 'rails-controller-testing'
end

group :development, :test do
  #gem 'thin'
  gem 'rspec-rails'
  gem "factory_bot_rails"
  #gem "ffaker"
  #gem "ffaker-cpfcnpj"
  gem 'faker'
  gem 'cpf_faker'

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-collection_matchers'
  gem 'rspec-mocks'
  gem 'rspec-activemodel-mocks'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
