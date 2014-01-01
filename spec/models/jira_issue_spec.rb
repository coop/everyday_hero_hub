require 'spec_helper'

describe JiraIssue do
  it "should list of issues for given keys" do
    VCR.use_cassette "jira_issues" do
      issue_keys = ["TA-1978", "TA-2135", "TA-2180"]

      issues = JiraIssue.find issue_keys

      assert_equal 3, issues.count
      assert_in_results "TA-1978", issues
      assert_in_results "TA-2135", issues
      assert_in_results "TA-2180", issues
    end
  end

  private

  def create_issue options
    status = options.delete(:status)
    options.merge! status: OpenStruct.new(name: status)
    OpenStruct.new options
  end

  def assert_in_results key, results
    selected = results.select { |result|
      result.key == key
    }
    assert_equal 1, selected.size
  end
end
