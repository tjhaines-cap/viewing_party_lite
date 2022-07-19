# frozen_string_literal: true

class UsersController < ApplicationController
  def new; end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/dashboard'
    elsif user.errors.full_messages == ['Email has already been taken']
      flash[:alert] = 'Oops, that email is already in use! Please try again with a unique email.'
      redirect_to '/register'
    elsif user.errors.full_messages == ["Name can't be blank"]
      flash[:alert] = 'Please enter a valid name.'
      redirect_to '/register'
    elsif user.errors.full_messages == ["Password confirmation doesn't match Password"]
      flash[:alert] = 'Passwords do not match.'
      redirect_to '/register'
    elsif user.errors.full_messages == ["Password can't be blank", "Password digest can't be blank"]
      flash[:alert] = 'Please enter a password.'
      redirect_to '/register'
    else
      flash[:alert] = 'Please enter a valid name and unique e-mail address.'
      redirect_to '/register'
    end
  end

  def show
    # @user = User.find(params[:id])
    @user = current_user
  end

  def discover
    # @user = User.find(params[:id])
    @user = current_user
  end

  def login_form; end

  def login_user
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/dashboard'
      flash[:success] = "Welcome back, #{user.email}!"
    else
      redirect_to '/login'
      flash[:error] = 'Invalid Credentials'
    end
  end

  def logout
    session.destroy
    redirect_to '/'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
