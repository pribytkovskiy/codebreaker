require './modules/errors'
require './modules/validation'
require './modules/console'
require './modules/game'
require './modules/storage'
require 'i18n'

I18n.load_path << Dir[File.expand_path('config/locales') + '/*.yml']
I18n.default_locale = :en
