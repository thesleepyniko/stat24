class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
    @photo = Rails.cache.read("random_photo")
    if @photo == nil
      @photo = ""
    else
      @author = @photo["author"]
      @acft = @photo["airline"]
      @photo = @photo["url"]
    end
    render :new
  end

  def create
    user = request.env["omniauth.auth"]
    user_info = user["info"]
    remember_me = request.env["omniauth.params"]["remember_me"] # will return either a 1 or will be nil
    existing_remember_me = cookies.encrypted["remember_me"]
    user = User.find_or_create_by(provider: user["provider"], uid: user["uid"]) do |u|
      u.provider = user["provider"] # should be discord, unless it was via /auth/dev
      u.uid = user["uid"]
      u.username = user_info["nickname"] # nickname is actually the username
      u.avatar_url = user_info["image"]
      u.units = "metric"
      u.public_profile = false
      u.onboarding_complete = false
    end
    if !existing_remember_me && remember_me
      raw_token = SecureRandom.hex(16)
      remember_me_obj = UserSession.find_or_create_by(user: user) do |u|
        u.token_digest = Digest::SHA256.hexdigest(raw_token)
        u.expires_at = DateTime.now + 14
        u.user_agent = request.user_agent
      end
      if !remember_me_obj.save
        raise "Attempted to save new token and failed"
      end
      cookies.encrypted["remember_me"] = raw_token
    end
    session[:user_id] = user.id
    if user.onboarding_complete?
      # redirect to the main page
    else
      redirect_to onboarding_path
    end
  end
end

# ActiveRecord::Schema[8.1].define(version: 2026_06_25_234417) do
#   create_table "users", force: :cascade do |t|
#     t.string "avatar_url"
#     t.datetime "created_at", null: false
#     t.boolean "onboarding_complete"
#     t.string "provider"
#     t.boolean "public_profile"
#     t.string "timezone"
#     t.string "uid"
#     t.string "units"
#     t.datetime "updated_at", null: false
#     t.string "username" check
#   end
# end

# omniauth hash stuff
# provider (required) - The provider with which the user authenticated (e.g. 'twitter' or 'facebook')
# uid (required) - An identifier unique to the given provider, such as a Twitter user ID. Should be stored as a string.
# info (required) - A hash containing information about the user
#   name (required) - The best display name known to the strategy. Usually a concatenation of first and last name, but may also be an arbitrary designator or nickname for some strategies
#   email - The e-mail of the authenticating user. Should be provided if at all possible (but some sites such as Twitter do not provide this information)
#   nickname - The username of an authenticating user (such as your @-name from Twitter or GitHub account name)
#   first_name
#   last_name
#   location - The general location of the user, usually a city and state.
#   description - A short description of the authenticating user.
#   image - A URL representing a profile image of the authenticating user. Where possible, should be specified to a square, roughly 50x50 pixel image.
#   phone - The telephone number of the authenticating user (no formatting is enforced).
#   urls - A hash containing key value pairs of an identifier for the website and its URL. For instance, an entry could be "Blog" => "http://intridea.com/blog"
# credentials - If the authenticating service provides some kind of access token or other credentials upon authentication, these are passed through here.
# token - Supplied by OAuth and OAuth 2.0 providers, the access token.
# secret - Supplied by OAuth providers, the access token secret.
# expires - Boolean indicating whether the access token has an expiry date
# expires_at - Timestamp of the expiry time. Facebook and Google Plus return this. Twitter, LinkedIn don't.
# extra - Contains extra information returned from the authentication provider. May be in provider-specific formats.
# raw_info - A hash of all information gathered about a user in the format it was gathered. For example, for Twitter users this is a hash representing the JSON hash returned from the Twitter API.
