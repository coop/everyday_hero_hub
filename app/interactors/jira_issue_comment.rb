class JIRAIssueComment
  def initialize issue, client: JIRAClient.new
    @issue  = issue
    @client = client
  end

  def create_comment comment
    build_comment.save! body: comment
  end

  private

  attr_reader :client
  attr_reader :issue

  def build_comment
    client.Issue.find(issue.jira_id).comments.build
  end
end
