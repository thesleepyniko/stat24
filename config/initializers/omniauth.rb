Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :discord, Rails.application.credentials.dig(:discord, :discord_client_id), Rails.application.credentials.dig(:discord, :discord_client_secret), scope: "identify guilds.members.read guilds"
end
