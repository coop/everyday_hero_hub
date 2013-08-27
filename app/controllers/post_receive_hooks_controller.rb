require 'ip_address_whitelist'

class PostReceiveHooksController < ApplicationController
  expose :ip_address_whitelist
  expose :event
  expose :commenter

  before_action :verify_ip_address
  before_action :verify_supported_event

  def receive
    commenter.create_comment event.url

    head :no_content
  end

  private

  def verify_supported_event
    head :forbidden unless supported_events.include?(event_header)
  end

  def verify_ip_address
    head :forbidden unless ip_address_whitelist.include?(request.remote_ip)
  end

  def commenter
    @commenter ||= JIRAIssueComment.new event
  end

  def event_header
    request.headers['X-Github-Event']
  end

  def supported_events
    %w(issues)
  end

  def event
    @event ||= "events/#{event_header.singularize}".classify.constantize.new payload
  end

  def payload
    ActiveSupport::JSON.decode params[:payload].to_s
  rescue ActiveSupport::JSON.parse_error
    Hash.new
  end

  def ip_address_whitelist
    @ip_address_whitelist ||= IPAddressWhitelist.new(
      *ActiveSupport::JSON.decode(ENV.fetch('GITHUB_IP_ADDRESSES'))
    )
  end
end
