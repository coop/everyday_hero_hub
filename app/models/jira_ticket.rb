class JiraTicket
  def self.find keys
    jira = JIRAClient.new
    keys.map { |key|
      begin
        Rails.cache.fetch(key, :expires_in => 1200.seconds) do
          puts "Querying ticket #{key}"
          jira.Issue.jql("issueKey=#{key}").first
        end
      rescue
      end
    }.compact
  end

  def self.categorize tickets
    tickets.inject({}) { |hash, ticket|
      status = ticket.status.name
      list = hash.fetch status, []
      list << ticket
      hash[status] = list

      hash
    }
  end
end
