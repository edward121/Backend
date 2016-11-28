class HomeController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  def index
  end
  # Create account API
  # POST: /api/v1/accounts/create
  # parameters:
    # email:          String *required
    # password:       String *required minimum 6

  # results:
  #   return created user info

  def create
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'

    email         = params[:email].downcase
    password      = params[:password]

    if User.where(email:email).first.present?
      render json:{status: 0, data: 'This email already exists. Please try another email'} and return
    end
    user = User.new(email:email, password:params[:password])
    if user.save
      # if sign_in(:user, user)
      #   render :json => {status: 1, :data => "Please confirm your email"}
      # else
      #   render json: {status: 0, :data => 'Can not create account'}
      # end
      render :json => {status: 1, :data => "Please confirm your email"}
    else
      render :json => {status: 0, :data => user.errors.messages}
    end
  end
  # Destroy account API
  # POST: /api/v1/accounts/destroy
  # parameters:
  #   token:      String *required
  # results:
  #   return success value
  def destroy
    user   = User.find_by_token params[:token]
    if user.present?
      if user.destroy
        # sign_out(user)
        render :json => {status: 1, data: 'Deleted account'}
      else
        render :json => {status: 0, data: "Cannot delete this user"}
      end
    else
      render :json => {status: 0, data: "Cannot find user"}
    end
  end
  # Login API
  # POST: /api/v1/accounts/sign_in
  # parameters:
  #   email:      String *required
  #   password:   String *required
  # results:
  #   return user_info
  def create_session
    email    = params[:email]
    password = params[:password]

    resource = User.find_for_database_authentication( :email => email )
    if resource.nil?
      render :json => {status: 0, data: 'Access Denied'}
    else
      if resource.valid_password?( password )

        unless resource.confirmed?
          render :json => {status: 0, :data => "Please confirm your email"}
        else
          if resource.approved?
	           user = sign_in( :user, resource )
             render :json => {status: 1, :data => resource.info_by_json}
          elsif resource.status == 'denied'
            render :json => {status: 0, :data => "Access denied, please contact your language department for the correct login info"}
          else
            render :json => {status: 0, :data => "Waiting for admin approval"}
          end
        end
      else
        render :json => {status: 0,  data: "Password is wrong"}
      end
    end
  end

  #  LogOut API
  #  POST: /api/v1/accounts/sign_out
  #  parameters:
  #    token:      String *required
  #  results:
  #    return user_info
   def delete_session
    resource = User.find_by_token params[:token]

    if resource.nil?
      render :json => {status: 0, data:'No Such User'}
    else
      sign_out(resource)
      render :json => {status: 1, :data => 'sign out'}
    end
  end


end
