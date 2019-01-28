class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  
  def create
    auth = request.env['omniauth.auth']
    # Find an identity here
    @identity = Identity.find_with_omniauth(auth)

    if @identity.nil?
      # If no identity was found, create a brand new one here
      @identity = Identity.create_with_omniauth(auth)
    end

    if user_signed_in?
      if @identity.user == current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it
        # is the current user. So the identity is already associated with
        # this user. So let's display an error message.
        redirect_to '/league', notice: "Already linked that account!"
      else
        # The identity is not associated with the current_user so lets 
        # associate the identity
        @identity.user = current_user
        @identity.save
        redirect_to '/league', notice: "Successfully linked that account!"
      end
    else
      if @identity.user.present?
        # The identity we found had a user associated with it so let's
        # just log them in here
        self.current_user = @identity.user
        redirect_to '/league', notice: "Signed in!"
      else
        # No user associated with the identity so we need to create a new one
        @user = User.create_with_omniauth(auth)
        self.current_user = @user
        @identity.user = current_user
        @identity.save
        redirect_to '/league', notice: 'Thanks for registering'
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end