OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '256738771471692', 'f3093d0ffc8afb6899379d03e4b3caa0'
end