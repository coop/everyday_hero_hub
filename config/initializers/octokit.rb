Octokit.configure do |config|
  config.access_token  = ENV.fetch('GITHUB_ACCESS_TOKEN')
  config.auto_paginate = true
  config.middleware    = Faraday::Builder.new do |builder|
    builder.use :http_cache, store: Rails.cache, logger: Rails.logger
    builder.use Octokit::Response::RaiseError
    builder.adapter Faraday.default_adapter
  end
end
