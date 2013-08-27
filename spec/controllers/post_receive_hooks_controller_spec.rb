require 'spec_helper'

describe PostReceiveHooksController do
  describe 'POST receive' do
    it 'returns forbidden when ip address does not match' do
      controller.ip_address_whitelist = double 'Whitelist', include?: false

      post :receive

      expect(response).to be_forbidden
    end

    it 'return forbidden for unsupported events' do
      controller.ip_address_whitelist = double 'Whitelist', include?: true
      request.headers['X-Github-Event'] = 'pull_request'

      post :receive

      expect(response).to be_forbidden
    end

    it 'returns no_content when successful' do
      controller.ip_address_whitelist = double 'Whitelist', include?: true
      controller.commenter            = double('JIRAIssueComment').as_null_object
      controller.event                = double('Events::Issue').as_null_object
      request.headers['X-Github-Event'] = 'issues'

      post :receive

      expect(response).to be_successful
    end

    it 'comments on JIRA ticket when opening issue' do
      commenter = double('JIRAIssueComment').as_null_object
      controller.ip_address_whitelist = double 'Whitelist', include?: true
      controller.commenter            = commenter
      controller.event                = double 'Events::Issue', url: 'https://google.com'
      request.headers['X-Github-Event'] = 'issues'

      post :receive

      expect(commenter).to have_received(:create_comment).with('https://google.com')
    end
  end
end
