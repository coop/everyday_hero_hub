class GitLogParser
  def extract_ticket_keys log
    log.inject([]) { |keys, log_entry|
      match = log_entry.commit.message.scan /((?:TA|SUP|QIB)?-\d+)/
      keys << match if match
      keys.flatten
    }
  end
end
