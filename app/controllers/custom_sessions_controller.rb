class CustomSessionsController < Devise::SessionsController
  before_action :before_login, :only => :create
  after_action :after_login, :only => :create

  def before_login

  end

  def after_login
    if(current_user.email=="ameropa.logistics@gmail.com")
  		current_user.update_attribute :admin, true
  	end	
  end
end