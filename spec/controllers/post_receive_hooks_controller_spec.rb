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
      request.headers['X-Github-Event'] = 'issues'

      post :receive

      expect(response).to be_successful
    end
  end
end
