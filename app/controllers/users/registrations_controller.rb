class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  respond_to :json
  require 'json'
  before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    user = User.new(user_params)
    p 111111111111111111111111111
    p 'user.errors'
    p user.errors
      p 'user.confirm'
      p user.confirm
      render :json=> {:status => true,:message => "User created!", :user => user }, :status=>200
    if user.save
      p 22222222222222222222222222222222222222
      'p user'
      p user
      return
    else
      p 33333333333333333333333333
      warden.custom_failure!
      render :json=> user.errors, :status=>422
      p 'user.errors'
      p user.errors
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    params[:user][:role] = 'Sales'
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name,:last_name,:password, :password_confirmation])
  end

  private

  def user_params
    params.require(:user).permit(:role, :email, :first_name, :last_name, :password, :password_confirmation)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
