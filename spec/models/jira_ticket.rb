require 'spec_helper'

describe JiraTicket do
  it "should list of tickets for given keys" do
    VCR.use_cassette "jira_tickets" do
      ticket_keys = ["TA-1978", "TA-2135", "TA-2180"]

      tickets = JiraTicket.find ticket_keys

      assert_equal 3, tickets.count
      assert_in_results "TA-1978", tickets
      assert_in_results "TA-2135", tickets
      assert_in_results "TA-2180", tickets
    end
  end

  it "should categorize tickets by status" do
    tickets = [
      create_ticket(key: "TA-1", summary: "My Ticket", status: "In Progress"),
      create_ticket(key: "TA-2", summary: "Another Ticket", status: "In Progress"),
      create_ticket(key: "TA-3", summary: "Ticket 3", status: "To Do"),
      create_ticket(key: "TA-4", summary: "Ticket 4", status: "Peer Review"),
      create_ticket(key: "TA-5", summary: "Ticket 5", status: "Sign Off"),
      create_ticket(key: "TA-6", summary: "Ticket 6", status: "Sign Off"),
      create_ticket(key: "TA-7", summary: "Ticket 7", status: "Done")
    ]

    ticket_map = JiraTicket.categorize(tickets)

    assert_equal 1, ticket_map["To Do"].count
    assert_equal 2, ticket_map["In Progress"].count
    assert_equal 1, ticket_map["Peer Review"].count
    assert_equal 2, ticket_map["Sign Off"].count
    assert_equal 1, ticket_map["Done"].count
  end

  private

  def create_ticket options
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
