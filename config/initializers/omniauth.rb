# Configure the Omniauth gem
Rails.application.config.middleware.use OmniAuth::Builder do
  # Configure Facebook app & permissions
  provider :facebook, "525862300758263", "cffd79debd10d6fc847925abc77262e5", {:scope => 'email, user_photos, friends_photos, publish_stream, offline_access'}
end
