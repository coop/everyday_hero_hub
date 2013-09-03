class IssuesController < ApplicationController
  expose :qa_issues
  expose :peer_review_issues
  expose :issues
  expose :users

  private

  # All users who have open issues.
  #
  # @return [Array]
  def users
    issues.
      map { |issue| issue.user }.
      uniq { |user| user.login }.
      sort_by { |user| user.login.downcase }
  end

  # A pull request that has passed peer review and waiting for QA.
  #
  # @return [Array]
  def qa_issues
    issues.select { |issue| issue.title =~ /\AQA/ }
  end

  # Any pull request that is not prefixed with QA.
  #
  # @return [Array]
  def peer_review_issues
    issues.select { |issue| issue.title !~ /\AQA/ }
  end

  # Any GitHub issue for Everyday Hero that has an associated pull request.
  #
  # @return [Array]
  def issues
    @issues ||= Octokit.
      org_issues('everydayhero', filter: 'all', direction: 'asc').
      sort_by { |issue| issue.created_at }.
      select { |issue| issue.pull_request.rels[:html] }
  end
end
