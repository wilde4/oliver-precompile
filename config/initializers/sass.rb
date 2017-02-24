# Sass.load_paths << Sass::Importers::ThemeImporter.new
require 'sass'
require 'sass/plugin'
# Sass::Plugin.options[:load_paths] << Sass::Rails::ThemeImporter.new
Sass.load_paths << Sass::Rails::ThemeImporter.new
ENV['DEPLOY_SERVER'] == true
