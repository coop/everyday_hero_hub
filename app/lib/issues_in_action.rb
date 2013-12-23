class IssuesInAction
  def initialize repo, from_sha, until_sha
    @repo = repo
    @from_sha = from_sha
    @until_sha = until_sha
  end

  def git_log
    @git_log ||= GitLog.log(@repo, @from_sha, @until_sha).reverse
  end

  def jira_ticket_keys
    @jira_ticket_keys ||= GitLogParser.new.extract_ticket_keys git_log
  end

  def jira_ticket_list
    @jira_ticket_list ||= JiraTicket.find jira_ticket_keys
  end

  def jira_tickets
    @jira_tickets ||= JiraTicket.categorize jira_ticket_list
  end

  def categorize_issues issues
    issues.inject(empty_issues_hash) do |hash, issue|
      hash[issue_category(issue)] << issue
      hash
    end
  end

  def empty_issues_hash
    ["To Do", "In Progress", "Done"].inject({}) do |hash, column_name|
      hash[column_name] = []
      hash
    end
  end

  def issue_category issue
    case issue.status.name
    when "Open", "To Do"
      "To Do"
    when "In Progress", "Peer Review", "Sign Off"
      "In Progress"
    when "Done", "Resolved", "To Be Released"
      "Done"
    else
      "To Do"
    end
  end

  def jira_board_columns
    other_columns + (known_columns - hidable_columns)
  end

  def columns
    ["To Do", "In Progress", "Done"]
  end

  def hidable_columns
    ["Open", "To Be Released", "Resolved"].inject([]) { |columns, column_name|
      columns << column_name if jira_tickets.fetch(column_name, []).empty?
      columns
    }
  end

  def known_columns
    [
      "Open", "To Do", "In Progress", "Peer Review", "Sign Off",
      "To Be Released", "Resolved", "Done"
    ]
  end

  def other_columns
    jira_tickets.keys - known_columns
  end
end
