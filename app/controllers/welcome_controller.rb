class WelcomeController < ApplicationController
  # Factor these out... later
  APPID = "525862300758263"
  SECRET = "cffd79debd10d6fc847925abc77262e5"

  def index
    if !current_user?
      redirect_to welcome_login_path
      return
    end

    # Get the user info
    @graph = Koala::Facebook::API.new(current_user)
    @user = @graph.get_object("me")
    @name = @user["name"]
    @email = @user["email"]
    @friends = @graph.get_connections("me", "friends")
    @photos = @graph.get_connections("me", "photos")
  end

  def login
    if current_user?
      redirect_to welcome_index_path
      return
    end

    # Send an oauth request to Facebook
    @oauth = Koala::Facebook::OAuth.new(APPID, SECRET, welcome_callback_url)
    @fb_login_url = @oauth.url_for_oauth_code(:permissions => "email,user_photos,friends_photos,publish_stream")
  end

  def logout
    session[:access_token] = nil
    flash[:notice] = "Logged out"
    redirect_to welcome_index_path
  end

  # Callback from Facebook API
  def callback
    @oauth = Koala::Facebook::OAuth.new(APPID, SECRET, welcome_callback_url)
    session[:access_token] = @oauth.get_access_token(params[:code]) if params[:code]
    if session[:access_token]
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Error logging in"
    end
    redirect_to welcome_index_path
  end

  # Get the user from the session
  def current_user
    return session[:access_token]
  end

  # Get the user info hash from the cookies
  def current_user_2
    # Get the user from the current cookies
    begin
      @oauth = Koala::Facebook::OAuth.new(APPID, SECRET)
      @oauth.get_user_info_from_cookies(cookies)
    rescue
      nil
    end
  end

  # Test if we're logged in and can get the user info
  def current_user?
    return !current_user.nil?
  end
end
