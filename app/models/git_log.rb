class GitLog
  def initialize repo, branch
    @repo = repo
    @branch = branch
  end

  def self.log repo, from_sha, until_sha
    Octokit.compare("everydayhero/supporter", from_sha, until_sha).commits
  end
end
