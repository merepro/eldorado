require 'machinist/active_record'
require 'faker'

Avatar.blueprint do
  user { User.make }
  attachment_file_name { Faker::Lorem.words(2).join('.') }
end

Header.blueprint do
  user { User.make }
  attachment_file_name { Faker::Lorem.words(2).join('.') }
end

Theme.blueprint do
  user { User.make }
  attachment_file_name { Faker::Lorem.words(2).join('.') }
end

Upload.blueprint do
  user { User.make }
  attachment_file_name { Faker::Lorem.words(2).join('.') }
end

User.blueprint do
  login { Faker::Name.first_name }
  email { Faker::Internet.email }
  password { 'test' }
  time_zone { 'UTC' } # TODO remove when users are moved over to machinist
  online_at { Time.now } # TODO remove when we're doing something better than do_login
end
