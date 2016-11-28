module Endpoints
  class Accounts < Grape::API

    resource :accounts do

      # Accounts API test
      # /api/v1/accounts/ping
      # results  'gwangming'
      get :ping do
        { :ping => 'gwangming' }
      end

      # Reset Password
      # GET: /api/v1/accounts/forgot_password
      # parameters:
      #   email:      String *required
      # results:
      #   {status: 1, data: 'Email was sent successfully'}
      get :forgot_password do
        user = User.where(email:params[:email]).first
        if user.present?
          user.send_reset_password_instructions
          {status: 1, data: 'Email was sent successfully'}
        else
          {status: 0, data: 'Cannot find your email'}
        end
      end
      # Set device token
      # POST: /api/v1/accounts/set_device
      #   Parameters accepted
      #     token         String *
      #     device_token  String *
      #   Results
      #     {status: 1, data: set device_token}
      post :set_device do
        user = User.find_by_token params[:token]
        if user.present?
          user.update(device_token: params[:device_token])
          {status: 1, data: "Set device_token"}
        else
          {status: 0, data: "Please sign in"}
        end
      end
    end
  end
end
