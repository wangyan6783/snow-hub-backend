class Api::V1::UsersController < ApplicationController
  before_action :authorized, only: [:profile]

  def profile
    render json: { user: UserSerializer.new(current_user) }, status: :accepted
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      # create live chat user profile
      Rails.configuration.chatkit.create_user({ id: @user[:username], name: @user[:username] })
      # create jwt token to have user logged in directly
      @token = encode_token(user_id: @user.id)
      render json: { user: UserSerializer.new(@user), jwt: @token }, status: :created
    else
      render json: {message: 'Failed to create user'}, status: :not_acceptable
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: {message: "error"}, status: :not_acceptable
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :bio, :avatar)
  end
end
