require 'spec_helper'

describe GitLog do
  it "should retreive the git log between two commits" do
    VCR.use_cassette "git_log" do
      commits = GitLog.log 'supporter',
        "5f9d5684d5dda99c3983caaa08982e961c3a424a",
        "2a7b6493b699bfe8eeb5dfcc00fc4a0e1f972b3d"

      expect(commits.length).to eq(3)
    end
  end
end
