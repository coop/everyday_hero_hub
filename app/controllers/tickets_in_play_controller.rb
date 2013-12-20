class TicketsInPlayController < ApplicationController
  expose :git_log
  expose :jira_tickets

  private

  def git_log
    @git_log ||= GitLog.log params[:repo],
      params[:from_sha],
      params[:until_sha]
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
end
