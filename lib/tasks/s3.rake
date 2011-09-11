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
end
