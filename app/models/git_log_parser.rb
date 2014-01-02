class GitLogParser
  def extract_issue_keys log
    log.inject([]) { |keys, log_entry|
      match = log_entry.commit.message.scan /((?:TA|SUP|QIB)-\d+)/
      keys << match if match
      keys.flatten
    }.uniq
  end
end
