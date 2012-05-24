require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe "failure" do
      
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"        # fill_in :user_name works as user_name is the CSS id of the text box and "Name" is the label of the text box
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success", :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "sign in/out" do
    
    describe "failure" do
      
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,     :with => ""
        fill_in :password,  :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do
        integration_sign_in(Factory(:user))
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in 
      end
    end
  end
  
  describe "deleting users" do
    
    describe "for admin users" do
      it "should be possible" do
        integration_sign_in(Factory(:user, :email => "admin@example.com", :admin => true))
        get 'users'
        click_link "Delete"
        response.should be_success
      end
    end
    
    describe "for non-admin users" do
      it "should not be possible" do
        integration_sign_in(Factory(:user))
        get 'users'
        response.should_not have_selector("a", :content => "delete")
      end
    end
  end
end