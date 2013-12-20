class JiraTicket
  def self.find keys
    jql = keys.map { |key| "issueKey=#{key}" }.join(" or ")
    JIRAClient.new.Issue.jql jql
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
