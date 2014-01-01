client = JIRAClient.new
result = client.Issue.jql "issueKey=TA-2135 or issueKey=TA-2194"

commit = Octokit.commit "everydayhero/supporter", "7f1690068bd8bb64aa8c9f343c30cb7842fd4888"
commit.commit.author.date
commit.commit.message
Octokit.commits("everydayhero/supporter", "master", :since => "2013-12-18T03:05:42Z", :until => "2013-12-18T03:53:22Z").length

diff = Octokit.compare "everydayhero/supporter", "5f9d5684d5dda99c3983caaa08982e961c3a424a", "f63694112c8150001101de5995514e505e2a856a"
diff.commits.each { |c| puts c.commit.message }
