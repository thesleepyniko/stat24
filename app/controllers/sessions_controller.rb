class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = request.env["omniauth.auth"]
    user_info = user["info"]
    user = User.find_or_create_by(uid: user["uid"]) do |u|
        u.provider = user["provider"] # should be discord, unless it was via /auth/dev
        u.uid = user["uid"]
        u.username = user_info["nickname"] # nickname is actually the username
        u.avatar_url = user_info["image"]
        u.units = "metric"
        u.public_profile = false
        u.onboarding_complete = false
    end
    session[:user_id] = user.id
    redirect_to onboarding_path
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