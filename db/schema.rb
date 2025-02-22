# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110911002200) do

  create_table "articles", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", :default => 0, :null => false
  end

  create_table "avatars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "current_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "attachment_remote_url"
  end

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "position", :default => 0
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config", :force => true do |t|
    t.integer "associated_id"
    t.string  "associated_type"
    t.string  "namespace"
    t.string  "key",             :limit => 40, :null => false
    t.string  "value"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "date"
    t.boolean  "reminder"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["date"], :name => "index_events_on_date"

  create_table "forums", :force => true do |t|
    t.integer "category_id"
    t.string  "name"
    t.text    "description"
    t.integer "topics_count", :default => 0
    t.integer "posts_count",  :default => 0
    t.integer "position",     :default => 0
  end

  create_table "headers", :force => true do |t|
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes",                   :default => 0
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "attachment_remote_url"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
  end

  add_index "messages", ["created_at"], :name => "index_messages_on_created_at"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by"
  end

  add_index "posts", ["topic_id", "created_at"], :name => "index_posts_on_topic_id_and_created_at"
  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id"

  create_table "ranks", :force => true do |t|
    t.string  "title"
    t.integer "min_posts"
  end

  create_table "settings", :force => true do |t|
    t.string  "title"
    t.string  "tagline"
    t.text    "announcement"
    t.text    "footer"
    t.string  "theme"
    t.string  "favicon"
    t.string  "time_zone"
    t.boolean "private",           :default => false
    t.string  "login_message"
    t.string  "admin_only_create", :default => "",    :null => false
    t.boolean "clickable_header",  :default => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer "user_id"
    t.integer "topic_id"
  end

  create_table "themes", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "attachment_remote_url"
  end

  create_table "topics", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.integer  "views",        :default => 0
    t.integer  "posts_count",  :default => 0
    t.integer  "last_post_id"
    t.datetime "last_post_at"
    t.integer  "last_post_by"
    t.boolean  "locked"
    t.boolean  "sticky",       :default => false
    t.integer  "forum_id"
  end

  add_index "topics", ["forum_id", "last_post_at"], :name => "index_topics_on_forum_id_and_last_post_at"
  add_index "topics", ["forum_id", "sticky", "last_post_at"], :name => "index_topics_on_sticky_and_last_post_at"

  create_table "uploads", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "attachment_remote_url"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "password_hash"
    t.datetime "created_at"
    t.boolean  "admin",              :default => false
    t.integer  "posts_count",        :default => 0
    t.string   "signature"
    t.text     "bio"
    t.datetime "profile_updated_at"
    t.datetime "online_at"
    t.string   "avatar"
    t.string   "auth_token"
    t.datetime "auth_token_exp"
    t.string   "time_zone"
    t.string   "ban_message"
    t.datetime "banned_until"
    t.datetime "chatting_at"
    t.boolean  "logged_out",         :default => false
    t.integer  "articles_count",     :default => 0
    t.datetime "all_viewed_at"
  end

  add_index "users", ["chatting_at"], :name => "index_users_on_chatting_at"

  create_table "viewings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "viewings", ["topic_id"], :name => "index_viewings_on_topic_id"

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
