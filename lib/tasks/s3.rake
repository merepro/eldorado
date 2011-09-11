require 'aws/s3'

namespace :s3 do
  task :create => :environment do
    puts "Reading config/settings/production.local.yml and creating a bucket on s3 for the production environment..."
    CONFIG = YAML.load_file('config/settings/production.local.yml') rescue {}
    AWS::S3::Base.establish_connection!(
      :access_key_id => CONFIG['s3_access_id'],
      :secret_access_key => CONFIG['s3_secret_key']
    )
    AWS::S3::Bucket.create(CONFIG['s3_bucket_name'])
    puts "OK"
  end

  task :rename => :environment do
    CONFIG = YAML.load_file('config/settings/production.local.yml') rescue {}
    AWS::S3::Base.establish_connection!(
      :access_key_id => CONFIG['s3_access_id'],
      :secret_access_key => CONFIG['s3_secret_key']
    )
    objects = AWS::S3::Bucket.objects(CONFIG['s3_bucket_name'], :prefix => 'avatars')
    objects.each do |object|
      unless object.key =~ /avatars\/(?:original|small|medium|large)_/
        new_name = File.dirname(object.key) + '/original_' + File.basename(object.key)
        AWS::S3::S3Object.rename object.key, new_name, CONFIG['s3_bucket_name']
        puts "renamed #{ object.key } to #{ new_name }"
      end
    end
  end
end
