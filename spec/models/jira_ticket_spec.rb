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
