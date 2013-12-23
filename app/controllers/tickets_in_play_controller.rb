class TicketsInPlayController < ApplicationController
  expose :git_log
  expose :jira_tickets
  expose :jira_board_columns
  expose :has_params

  def index

  end

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

  def jira_tickets
    issues_in_action.jira_tickets
  end
end
