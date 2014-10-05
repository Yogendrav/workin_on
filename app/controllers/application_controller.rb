class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_admin!
  
  helper_method :current_company, :yyyy_mm_dd

  UserNotDisable = Class.new(StandardError)
  UserOwnAccount = Class.new(StandardError)
  AccessDenied = Class.new(StandardError)

  rescue_from ActiveRecord::RecordNotFound, UserOwnAccount, UserNotDisable, AccessDenied do |ex|
    error(ex)
  end

  private

  def current_company
    @current_company ||= current_admin.company
  end

  def error(err)
    @error = err
    render 'home/error'
  end
  
  def yyyy_mm_dd(datetime)
    datetime.to_date.strftime("%Y-%m-%d")
  end
end