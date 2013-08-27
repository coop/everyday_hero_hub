require 'jira_client'

JIRAClient.configure do |config|
  config.username     = ENV.fetch('JIRA_USERNAME')
  config.password     = ENV.fetch('JIRA_PASSWORD')
  config.site         = ENV.fetch('JIRA_SITE')
  config.context_path = ENV.fetch('JIRA_CONTEXT_PATH')
  config.auth_type    = ENV.fetch('JIRA_AUTH_TYPE').to_sym
end
