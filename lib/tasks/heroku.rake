namespace :heroku do
  task :config do
    puts "Reading config/settings/production.local.yml and sending production configuration variables to Heroku..."
    CONFIG = YAML.load_file('config/settings/production.local.yml') rescue {}
    command = "heroku config:add"
    CONFIG.each {|key, val| command << " #{key}=#{val.to_s.gsub(/ /, '\ ')} " if val }
    system command
  end
end
