module Events
  class Issue
    def initialize data
      @data = data
    end

    def repo
      data.rels[:html].href.gsub('https://github.com/', '').gsub(/\/issues\/\d+/, '')
    end

    def title
      data.title
    end

    def url
      data.pull_request.rels[:html].href
    end

    def created_at
      data.created_at
    end

    def state
      assigned_to_qa? ? 'qa' : 'peer_review'
    end

    def pull_request?
      data.pull_request.rels[:html].present?
    end

    def to_json
      {
        created_at: created_at,
        repo: repo
        state: state,
        title: title,
        url: url,
      }.to_json
    end

    private

    attr_reader :data

    def assigned_to_qa?
      data.assignee && testers.include?(data.assignee.login)
    end

    def testers
      %w(kanikasethi janahanEDH)
    end
  end
end
