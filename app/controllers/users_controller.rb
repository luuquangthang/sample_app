    class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: %i[show edit update destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

    def new
        @user = User.new

    end
    def index
      @users = User.paginate(page: params[:page])
    end

    def create
        @user = User.new(user_params) # Not the final implementation!
        if @user.save
          flash[:success] = "User is created"
          redirect_to @user
        else
        render 'new'
        end
    end

    def show
      @microposts = @user.microposts.paginate(page: params[:page])
    end 

    def edit; end

    def update
      if @user.update(user_params)
        flash[:success] = "User is updated"
        redirect_to @user
      else
        render :edit
      end
    end
   
    def destroy
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end 
      
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def following
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.following.paginate(page: params[:page])
      render 'show_follow'
    end

    def followers
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    end

    
    private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end

    def find_user
      @user = User.find_by(id: params[:id])
      unless @user
        redirect_to root_path
      end
    end
end