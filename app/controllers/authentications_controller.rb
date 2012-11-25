class AuthenticationsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    # See if we already have an Authentication for this user
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authentication
      flash[:notice] = "Signed in!"
      sign_in_and_redirect(:user, authentication.user)
    else
      # Create a new user
      user = User.new
      user.password = Devise.friendly_token[0,20]
      user.apply_omniauth(auth)
      if user.save
        flash[:notice] = "Created new account!"
        sign_in_and_redirect(:user, user)
      else
        flash[:error] = "Error creating a new account!"
        redirect_to root_url
      end
    end
  end
end
