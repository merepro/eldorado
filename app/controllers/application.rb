class ApplicationController < ActionController::Base
  
  around_filter :set_timezone
  before_filter :auth_token_login, :check_bans, :update_online_at, :get_options, :get_stats, :get_reminders
  helper_method :current_user, :logged_in?, :force_login, :is_online?, :admin?, :check_admin, :redirect_to_home, :can_edit?
  
  session :session_key => '_eldorado_session_id'
  
  filter_parameter_logging "password"
    
  include ExceptionLoggable
  
  protected
    
  def current_user
    @current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
  end
    
  def logged_in?()
    current_user != 0
  end
  
  def force_login
    redirect_to login_path and return false unless logged_in?
  end

  def auth_token_login
    return if logged_in? || cookies[:auth_token].nil?
    user = User.find_by_auth_token(cookies[:auth_token])
    if user && Time.now.utc < user.auth_token_exp
      session[:user_id] = user.id 
      session[:online_at] = user.online_at
      redirect_to request.request_uri and return false
    end
  end
        
  def check_bans
    return unless logged_in?
    return if request.path_parameters['action'] == 'logout'
    @ban = Ban.find(:first, :conditions => ["user_id = ? or ip = ? or email = ? and (expires_at > ? or expires_at is ?)", current_user.id, request.remote_ip, current_user.email, Time.now.utc, nil])
    if @ban
      flash[:notice] = 'This account is banned' 
      flash[:notice] << ' until ' + @ban.expires_at.strftime("%B %d, %Y") unless @ban.expires_at.blank?
      flash[:notice] << ' with the message: ' + @ban.message unless @ban.message.blank?
      redirect_to logout_path and return false
    end
  end
  
  def update_online_at
    return unless logged_in?
    session[:online_at] = current_user.online_at if current_user.online_at + 10.minutes < Time.now.utc 
    User.update_all ['online_at = ?', Time.now.utc], ['id = ?', current_user.id]
  end
        
  def admin?()
    logged_in? && (current_user.admin == true)
  end
  
  def check_admin
    redirect_to home_path and return false unless admin?
  end
  
  def redirect_to_home
    redirect_to home_path and return false
  end
  
  def can_edit?(current_item)
    return false unless logged_in?
    if request.path_parameters['controller'] == "users"
      return current_user.admin? || (current_user.id == current_item.id) 
    else
      return current_user.admin? || (current_user.id == current_item.user_id) 
    end
  end

  def set_timezone
    TzTime.zone = logged_in? ? current_user.tz : TZInfo::Timezone.get('UTC')
    yield
    TzTime.reset!
  end
  
  def get_reminders
    if logged_in?
      @reminders = Event.find(:all, :order => 'date asc', :conditions => ["DATE(date) = ? and reminder = ?", Date.today, true])
    else
      @reminders = Event.find(:all, :order => 'date asc', :conditions => ["DATE(date) = ? and reminder = ? and private = ?", Date.today, true, false])
    end
  end
  
  def get_stats
    @newest_user = User.find(:first, :order => "created_at desc")
    @user_count = User.count
    @posts_count = Forum.sum('posts_count')
  end
  
  def get_options
    @options = Option.find(:first)
    if @options.blank? # set default options
      return if (Category.count != 0) || (Forum.count != 0) || (Option.count != 0) || (Post.count != 0) || (Topic.count != 0) || (User.count != 0)
      @option = Option.new(:site_title => 'El Dorado.org', :site_tagline => 'All an elaborate, unapproachable, unprofitable, retributive joke', :announcement => '', :footer => '<p style="text-align:right;margin:0;">Powered by El Dorado | <a href="http://almosteffortless.com">&aelig;</a></p>', :newest_user => 'Newest User', :admin_rank => 'Administrator')
      @option.save!
      @category = Category.new(:name => 'Test Category')
      @category.save!
      @forum = @category.forums.build(:name => 'Test Forum', :description => "This is just a test forum")
      @forum.save!
      char = ("a".."z").to_a + ("1".."9").to_a; pass = Array.new(6, '').collect{char[rand(char.size)]}.join
      @user = User.new(:login => 'Administrator', :email => 'example@example.com', :password => pass) 
      @user.admin = true
      @user.save!
      @topic = @user.topics.build(:title => 'Test post', :forum_id => 1)
      @topic.save!
      @post = @user.posts.build(:body => 'This is just a test post')
      @post.topic_id = 1
      @post.save!
      flash[:notice] = "Setup complete. You can now log in as 'Administrator' with the password '#{pass}'"
      @options = Option.find(:first)
    end
  end
            
end