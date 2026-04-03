# frozen_string_literal: true

# config/initializers/locale.rb

# Where the I18n library should search for translation files
I18n.load_path += Rails.root.glob('lib/locale/*.{rb,yml}')

# Permitted locales available for the application
I18n.available_locales = %i[en pt-BR]

# Set default locale to something other than :en
I18n.default_locale = :'pt-BR'
