class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]  # employs authenticate (see definition near the bottom) before doing anything, 
                                                                            # but only (options hash) for the index, edit, update & destroy methods (see definitions below)
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def new
    unless signed_in?
      @user = User.new
      @title = "Sign up"
    else
      flash[:info] = "You cannot create a new account because you're already logged in!"
      redirect_to root_path
    end
  end
  
  def create
    @user = User.new(params[:user])
    # When certain signup info is put in, the above is exactly equal to: 
    # @user = User.new(:name => "Foo Bar", :email => "foo@invalid", :password => "dude", :password_confirmation => "dude")
    
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user   # sends the user who successfully signs up to their profile page
    else
      @title = "Sign up"
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if current_user == @user
      flash[:notice] = "You cannot destroy yourself"
    else
      @user.destroy
        flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end