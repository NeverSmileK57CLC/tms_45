class Admin::AdminController < ApplicationController
  before_action :verify_admin

  private
  def verify_admin
    unless logged_in? && current_user.admin?
      flash[:warning] = t :permission_denied
      redirect_to root_url
    end
  end
end
