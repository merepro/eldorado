class Setting < ActiveRecord::Base
  
  attr_accessible :title, :tagline, :announcement, :footer, :theme, :favicon, :time_zone, :private, :login_message, :admin_only_create, :clickable_header
    
  validates_presence_of :time_zone
      
  def theme
    read_attribute(:theme) # TODO not sure why this is needed, but tests are failing without it
  end
  
  def self.defaults
    Setting.new(
      :announcement => '',
      :title => I18n.t(:title, :scope => :default_settings ),
      :tagline => I18n.t(:tagline, :scope => :default_settings),
      :footer => "<p style=\"text-align:right;margin:0;\">#{I18n.t(:powered_by)} <a href=\"http://github.com/trevorturk/eldorado/\">#{I18n.t(:el_dorado)}</a></p>".html_safe,
      :login_message => I18n.t(:login_message, :scope => :default_settings),
      :time_zone => 'UTC'
    ).save
  end
  
  def self.current_theme
    current_url = Setting.first.theme
    Theme.all.detect {|t| t.attachment.url == current_url }
  end
  
  def to_s
    title
  end
  
end
