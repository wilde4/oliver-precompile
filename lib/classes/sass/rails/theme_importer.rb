require 'sass/importers/base'
module Sass
  module Rails
    class ThemeImporter < Sass::Importers::Base
      # no such thing as relative files for this
      def find_relative(uri, base, options)
        nil
      end


      def find(uri, options)
        # puts options.inspect
        if uri.start_with?('$theme')
          uri = uri.sub('$theme/', '')
          # full_filename = ::Rails.root.to_s + "/test-themes/#{ENV['THEME_NAME']}/assets/stylesheets/#{uri}.scss"
          
          full_filename = "/srv/www/volcanic_deploy/shared/themes/#{ENV["MODE"]}/#{ENV["THEME_NAME"]}/assets/stylesheets/#{uri}.scss"

          Sass::Engine.new(File.read(full_filename), options)
        else
          nil
        end
      end

      def to_s
        'Searching for the theme for files'
      end

      def key(name, _options)
        [self.class.name + ':' + name + ':' + ENV['THEME_NAME'],
         name]
      end

      def mtime(uri, _options)
        if uri.start_with?('$theme')
          uri = uri.sub('$theme/', '')
          # full_filename = ::Rails.root.to_s + "/app/themes/#{ENV['MODE']}/#{ENV['THEME_NAME']}/assets/stylesheets/#{uri}.scss"
          full_filename = "/srv/www/volcanic_deploy/shared/themes/#{ENV["MODE"]}/#{ENV["THEME_NAME"]}/assets/stylesheets/#{uri}.scss"
          File.mtime(full_filename)
        else
          nil
        end
      end
    end
  end
end