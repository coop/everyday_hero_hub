class IssuesInAction
  attr_accessor :jira_ticket_list

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
    @jira_tickets ||= categorize_issues jira_ticket_list
  end

  private

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
end
