class GitLogParser
  def extract_ticket_keys log
    log.inject([]) { |keys, log_entry|
      match = log_entry.commit.message.match /(TA|SUP|QIB)-\d+/
      keys << match[0] if match
      keys
    }
  end
end
