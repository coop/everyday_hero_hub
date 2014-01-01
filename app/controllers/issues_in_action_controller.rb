class IssuesInActionController < ApplicationController
  expose :git_log
  expose :jira_issues
  expose :has_params

  private

  def has_params
    params[:repo] && params[:from_sha] && params[:until_sha]
  end

  def issues_in_action
    @issues_in_action ||= IssuesInAction.new params[:repo],
      params[:from_sha],
      params[:until_sha]
  end

  def git_log
    issues_in_action.git_log
  end

  def jira_issues
    issues_in_action.jira_issues
  end
end
