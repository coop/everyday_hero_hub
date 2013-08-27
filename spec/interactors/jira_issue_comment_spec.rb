require 'spec_helper'

describe JIRAIssueComment do
  # This test is extremely shitty but the client library doesn't make it easy.
  # It's possible that rspec has a solution for this problem.
  describe '#create_comment' do
    it 'comments on issue' do
      issue           = double('Issue').as_null_object
      comment         = double('Comment').as_null_object
      comment_builder = double 'CommentBuilder', build: comment
      jira_issue      = double 'JIRA::Resource::Issue', comments: comment_builder
      issue_finder    = double 'IssueFinder', find: jira_issue
      client          = double 'JIRA::Client', Issue: issue_finder
      commenter       = JIRAIssueComment.new issue, client: client

      commenter.create_comment 'a comment'

      expect(client).to have_received(:Issue)
    end
  end
end
