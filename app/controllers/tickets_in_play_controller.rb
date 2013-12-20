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

  def git_log
    @git_log ||= GitLog.log(params[:repo],
      params[:from_sha],
      params[:until_sha]).reverse
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

  def jira_board_columns
    other_columns + (known_columns - hidable_columns)
  end

  def hidable_columns
    ["Open", "To Be Released"].inject([]) { |columns, column_name|
      columns << column_name if jira_tickets.fetch(column_name, []).empty?
      columns
    }
  end

  def known_columns
    [
      "Open", "To Do", "In Progress", "Peer Review", "Sign Off",
      "To Be Released", "Done"
    ]
  end

  def other_columns
    jira_tickets.keys - known_columns
  end
end
