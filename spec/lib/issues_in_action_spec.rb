require 'spec_helper'

describe IssuesInAction do
  let(:issues_in_action) { IssuesInAction.new 'dummy_repo', 'abc', 'abc' }

  it "should group 'Open' issues under 'To Do'" do
    issue = create_issue(name: "My Issue", status: "Open")

    assert_issue_category issue, "To Do"
  end

  it "should group 'To Do' issues under 'To Do'" do
    issue = create_issue(name: "My Issue", status: "To Do")

    assert_issue_category issue, "To Do"
  end

  it "should group 'In Progress' issues under 'In Progress'" do
    issue = create_issue(name: "My Issue", status: "In Progress")

    assert_issue_category issue, "In Progress"
  end

  it "should group 'Peer Review' issues under 'In Progress'" do
    issue = create_issue(name: "My Issue", status: "Peer Review")

    assert_issue_category issue, "In Progress"
  end

  it "should group 'Sign Off' issues under 'In Progress'" do
    issue = create_issue(name: "My Issue", status: "Sign Off")

    assert_issue_category issue, "In Progress"
  end

  it "should group 'Done' issues under 'Done'" do
    issue = create_issue(name: "My Issue", status: "Done")

    assert_issue_category issue, "Done"
  end

  it "should group 'Resolved' issues under 'Done'" do
    issue = create_issue(name: "My Issue", status: "Resolved")

    assert_issue_category issue, "Done"
  end

  it "should group 'To Be Released' issues under 'Done'" do
    issue = create_issue(name: "My Issue", status: "To Be Released")

    assert_issue_category issue, "Done"
  end

  it "should group unknown status issues under 'To Do'" do
    issue = create_issue(name: "My Issue", status: "Something Else")

    assert_issue_category issue, "To Do"
  end

  private

  def assert_issue_category issue, category
    expected_issues = empty_issues_hash
    expected_issues[category] << issue

    issues_in_action.jira_ticket_list = [issue]
    categorized_issues = issues_in_action.jira_tickets

    assert_equal expected_issues, categorized_issues
  end

  def empty_issues_hash
    {
      "To Do" => [],
      "In Progress" => [],
      "Done" => []
    }
  end

  def create_issue options
    status = options.delete(:status)
    options.merge! status: OpenStruct.new(name: status)
    OpenStruct.new options
  end
end
