class Event < ActiveRecord::Base
  
  attr_accessible :title, :description, :date, :reminder
  
  belongs_to :user
  
  validates_presence_of :title, :description, :date, :user_id
    
  scope :reminders, lambda {|*args| where(:reminder => true, :date => Time.now.utc-2.hours..Time.now.utc+6.hours).order('date asc')}
  
  def to_s
    title
  end
  
  def to_param
    "#{id}-#{to_s.parameterize}"
  end
  
end
