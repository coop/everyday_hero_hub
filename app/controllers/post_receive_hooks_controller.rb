require 'ip_address_whitelist'

class PostReceiveHooksController < ApplicationController
  before_action :verify_supported_event

  # Any supported event will be received, made better and forwarded to Pusher
  # for rendering client side.
  #
  # @return nothing.
  def receive
    if event.pull_request?
      Pusher.trigger 'pull-requests', event.action, event.to_json
    end
  rescue Pusher::Error => e
    # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
  end

  private

  def verify_supported_event
    head :forbidden unless supported_events.include?(event_header)
  end

  def event_header
    request.headers['X-Github-Event']
  end

  def supported_events
    %w(issues)
  end

  def event
    "event/#{event_header.singularize}".classify.constantize.new payload
  end

  def payload
    ActiveSupport::JSON.decode params[:payload]
  end

  def verify_ip_address
    unless ip_address_whitelist.include? request.remote_ip
      head :forbidden
      false
    end
  end

  def ip_address_whitelist
    @ip_address_whitelist ||= IPAddressWhitelist.new(
      *ActiveSupport::JSON.decode(ENV.fetch('GITHUB_IP_ADDRESSES'))
    )
  end
end
