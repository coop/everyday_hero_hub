require 'spec_helper'

describe GitLogParser do
  it "should extract Jira ticket numbers from a log" do
    log = [
      create_commit_log("Did some stuff on TA-1234"),
      create_commit_log("Merge pull request 123\n\nPR - [SUP-4321] - make stuff"),
      create_commit_log("just a commit")
    ]

    ticket_keys = GitLogParser.new.extract_ticket_keys(log)

    assert_equal ["TA-1234", "SUP-4321"], ticket_keys
  end

  it "should extract multiple jira keys from single commit" do
    log = [
      create_commit_log("Did some stuff on [TA-1234, TA-567 and SUP-888]")
    ]

    ticket_keys = GitLogParser.new.extract_ticket_keys(log)

    assert_equal ["TA-1234", "TA-567", "SUP-888"], ticket_keys
  end

  it "should not contain duplicates" do
    log = [
      create_commit_log("Did some stuff on [TA-1234]"),
      create_commit_log("Did some stuff on [TA-1234]"),
    ]

    ticket_keys = GitLogParser.new.extract_ticket_keys(log)

    assert_equal ["TA-1234"], ticket_keys
  end

  it "should not match partial matches" do
    log = [
      create_commit_log("merge branch aa-ta-1234")
    ]

    ticket_keys = GitLogParser.new.extract_ticket_keys(log)

    assert_equal [], ticket_keys
  end

  private

  def create_commit_log message
    OpenStruct.new commit: OpenStruct.new(message: message)
  end
end
