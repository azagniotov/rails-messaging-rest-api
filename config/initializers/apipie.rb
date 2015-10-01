Apipie.configure do |config|
  config.app_name                 = "RailsMessagingRestApi"
  config.api_base_url             = "/"
  config.doc_base_url             = "/apidoc"
  config.validate                 = false
  config.api_routes               = RailsMessagingRestApi::Application.routes
  # where is your API defined?
  config.api_controllers_matcher =
      %W(
        #{Rails.root}/app/controllers/api/v1/users_controller.rb
        #{Rails.root}/app/controllers/api/v1/sessions_controller.rb
      )
end
