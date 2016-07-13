namespace :assets do
  desc "Create compressed versions of images"
  task :precompile_image_compress => :environment do
    image_types = /\.(?:jpg|jpeg|png|gif)$/

    public_assets = File.join(
        Rails.root,
        "public",
        ENV['MODE'],
        ENV['THEME_NAME']
      )

    Dir["#{public_assets}/**/*"].each do |f|
      next unless f =~ image_types

      ImageOptim.new(:svgo => false, :pngout => false).optimize_image!(f)
    end
  end

  # Hook into existing assets:precompile task
  # Rake::Task["assets:precompile"].enhance do
  #   Rake::Task["assets:precompile_image_compress"].invoke
  # end
end