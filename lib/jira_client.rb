require 'jira_client/configuration'

module JIRAClient
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration= new_configuration
    @configuration = new_configuration
  end

  def self.configure
    yield configuration
  end

  def self.new
    JIRA::Client.new(
      username: configuration.username,
      password: configuration.password,
      site: configuration.site,
      context_path: configuration.context_path,
      auth_type: configuration.auth_type
    )
  end
end
