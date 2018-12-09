require './modules/game.rb'
require './modules/storage.rb'
require './modules/errors.rb'
require './modules/validation.rb'
require 'i18n'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
