# Sass.load_paths << Sass::Importers::ThemeImporter.new
require 'sass'
require 'sass/plugin'
require 'sass/rails/theme_importer'
# Sass::Plugin.options[:load_paths] << Sass::Rails::ThemeImporter.new
Sass.load_paths << Sass::Rails::ThemeImporter.new
