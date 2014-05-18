class IssuesInAction
  attr_accessor :jira_issue_list

  def initialize repo, from_sha, until_sha
    @repo = repo
    @from_sha = from_sha
    @until_sha = until_sha
  end

  def git_log
    @git_log ||= GitLog.log(@repo, @from_sha, @until_sha).reverse
  end

  def jira_issue_keys
    @jira_issue_keys ||= GitLogParser.new.extract_issue_keys git_log
  end

  def jira_issue_list
    @jira_issue_list ||= JiraIssue.find jira_issue_keys
  end

  def jira_issues
    @jira_issues ||= categorize_issues jira_issue_list
  end

  private

  def categorize_issues issues
    issues.inject(empty_issues_hash) do |hash, issue|
      hash[issue_category(issue)] << issue
      hash
    end
  end

  def empty_issues_hash
    ["To Do", "In Progress", "Sign Off", "Done"].inject({}) do |hash, column_name|
      hash[column_name] = []
      hash
    end
  end

  def issue_category issue
    case issue.status.name
    when "Open", "To Do"
      "To Do"
    when "In Progress", "Peer Review"
      "In Progress"
    when "Sign Off"
      "Sign Off"
    when "Done", "Resolved", "To Be Released", "Closed"
      "Done"
    else
      "To Do"
    end
  end
end
