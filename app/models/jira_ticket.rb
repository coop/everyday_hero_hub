class JiraTicket
  def self.find keys
    begin
      find_single_request keys
    rescue Exception => e
      puts e.inspect
      puts "Trying multiple requests."
      find_multiple_requests keys
    end
  end

  ## This method exists because getting all tix in one request returns
  # a HTTPError if one of the keys is not valid.
  # This allows us to skip involid keys and still display the valid ones.
  def self.find_multiple_requests keys
    keys.map { |key|
      begin
        Rails.cache.fetch(key, :expires_in => 1200.seconds) do
          puts "Querying ticket #{key}"
          JIRAClient.new.Issue.jql("issueKey=#{key}").first
        end
      rescue
      end
    }.compact
  end

  def self.find_single_request keys
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
