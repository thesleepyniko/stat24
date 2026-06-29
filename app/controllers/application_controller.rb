class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :resurrect_session
  before_action :require_login

  def resurrect_session
    existing_remember_me = cookies.encrypted["remember_me"]
    user_id = session[:user_id]
    if user_id == nil && existing_remember_me
      user_session = UserSession.find_by(
        token_digest:  Digest::SHA256.hexdigest(existing_remember_me)
      )
      if user_session == nil
        cookies.encrypted["remember_me"] = nil
        session[:user_id] = nil
      elsif user_session.expires_at <= DateTime.now
        cookies.encrypted["remember_me"] = nil
        session[:user_id] = nil
      else
        user_session.expires_at = DateTime.current + 14 # add 14 days to expiry
        if !user_session.save
          puts "Attempted to save new token and failed" # try not to fail every page if this happens
        end
        session[:user_id] = user_session.user_id
      end
    end
  end
  def require_login
    @current_user ||= User.find_by(id: session[:user_id])
    if !@current_user
      redirect_to login_path
    end
  end
end
