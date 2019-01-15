require './modules/validation'
require './modules/storage'
require './modules/console'
require './modules/mark'
require './modules/game'
require 'i18n'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
