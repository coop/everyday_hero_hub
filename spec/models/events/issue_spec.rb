require 'spec_helper'

describe Events::Issue do
  let(:agent) { Octokit::Client.new.agent }
  let(:data)  { ActiveSupport::JSON.decode(Rails.root.join('spec', 'fixtures', 'events', 'issue.json')) }
  let(:issue) { Events::Issue.new Sawyer::Resource.new(agent, data) }

  it '#repo' do
    expect(issue.repo).to eq('octocat/Hello-World')
  end

  it '#title' do
    expect(issue.title). to eq('Found a bug')
  end

  it '#url' do
    expect(issue.url). to eq('https://github.com/octocat/Hello-World/issues/1347')
  end

  it '#created_at' do
    expect(issue.created_at). to eq('2011-04-22T13:33:48Z')
  end

  it '#pull_request?' do
    expect(issue.pull_request?).to be_true
  end

  it '#to_json' do
    expect(issue.to_json).to eq("{\"created_at\":\"2011-04-22T13:33:48Z\",\"repo\":\"octocat/Hello-World\",\"state\":\"peer_review\",\"title\":\"Found a bug\",\"url\":\"https://github.com/octocat/Hello-World/issues/1347\"}")
  end
end
