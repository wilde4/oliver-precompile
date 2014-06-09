Bundler.require

ENV["THEME_NAME"] = "bootstrap"
BUILD_DIR = "#{File.dirname(__FILE__)}/public/assets/themes/#{ENV["THEME_NAME"]}"
DIGEST    = true

namespace :assets do

  task :precompile => :cleanup do
    
    sprockets = Sprockets::Environment.new

    sprockets.append_path "../../themes/bootstrap/assets"

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
