Bundler.require

BUILD_DIR = "#{File.dirname(__FILE__)}/public/assets"
DIGEST    = true

namespace :assets do

  task :compile => :cleanup do
    sprockets = Sprockets::Environment.new
    sprockets.append_path 'assets/images'
    sprockets.append_path 'assets/javascripts'
    sprockets.append_path 'assets/stylesheets'
    sprockets.append_path 'fonts'

    sprockets.each_logical_path do |logical_path|
      if asset = sprockets.find_asset(logical_path)
        target_filename =  DIGEST ? asset.digest_path : asset.logical_path
        prefix, basename = asset.pathname.to_s.split('/')[-2..-1]
        FileUtils.mkpath BUILD_DIR + '/' + prefix
        filename = BUILD_DIR + '/' + target_filename
        asset.write_to(filename)
      end
    end
  end

  # Cleanup asset directory
  task :cleanup do
    dirs = Dir.glob(File.join(BUILD_DIR, "{*}"))
    dirs.each do |dir|
      FileUtils.rm_rf dir
    end
  end

end
