namespace :github do
  def endpoint
    'http://' + ENV.fetch('APP_HOST') + '/receive'
  end

  def repos
    Octokit.org_repos 'everydayhero'
  end

  desc "Seed GitHub repositories with post receive hook endpoint"
  task seed: :environment do
    events = %w(issues pull_request)

    repos.each do |repo|
      if Octokit.hooks(repo.full_name).none? { |hook| hook.name == 'web' && hook.config.rels[:self].href == endpoint }
        puts "Adding post receive hook for #{repo.full_name}"
        Octokit.create_hook repo.full_name, 'web', {url: endpoint}, {events: events}
      end
    end
  end

  desc "Remove post receive hook from GitHub repositories"
  task deseed: :environment do
    repos.each do |repo|

      hooks = Octokit.hooks(repo.full_name).select do |hook|
        hook.name == 'web' && hook.config.rels[:self].href == endpoint
      end

      hooks.each do |hook|
        puts "Removing post receive hook for #{repo.full_name}"
        Octokit.remove_hook repo.full_name, hook.id
      end
    end
  end
end
