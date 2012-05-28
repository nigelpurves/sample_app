module SessionsHelper
  
  def sign_in(user)
    # cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    session[:user_id] = user.id
    current_user = user
  end
  
  def current_user=(user)   # defines a method 'current_user =' which is expressly designed to handle assignment to current_user. Its one argument is the RHS, in this case the user to be signed in
    @current_user = user    # this just sets an instance variable @current_user, effectively storing the user for later use
  end
  
  def current_user
    @current_user ||=User.find(session[:user_id]) if session[:user_id]
    # @current_user ||= user_from_remember_token        # the effect of '||=' ("or equals") assignment operator is to set the @current_user instance variable to the user 
  end                                                   # corresponding to the remember token, but only if @current_user is undefined. In other words the whole line calls
                                                        # the user_from_remember_token method the first time current_user is called, but on subsequent invocations returns
                                                        # current user WITHOUT calling from user_from_remember_token
  
  def signed_in?
    !current_user.nil?                                  # a user is signed in if current_user is NOT nil; uses the "not" operator which is '!'
  end
  
  def sign_out
    # cookies.delete(:remember_token)                     # effectively undoes the sign_in method by deleting the remember token and by setting the current user to nil
    session[:user_id] = nil
    current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  # the code above is equivalent to (but uses a shortcut by passing an options hash to the redirect_to function):
  #   flash[:notice] = "Please sign in to access this page."
  #   redirect_to signin_path

  private 
  
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end
  
  # commented out to enable sessions to be destroyed once the browser has been closed
  
  #  def user_from_remember_token
  #    User.authenticate_with_salt(*remember_token)
  #  end
    
  #  def remember_token
  #    cookies.signed[:remember_token] || [nil, nil]     # support for signed cookies in Rails is immature and a nil value for the cookie causes spurious test breakage...
  #  end                                                 #...returning [nil, nil] fixes the issue
  


end