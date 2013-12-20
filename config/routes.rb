EverydayHeroHub::Application.routes.draw do
  post '/receive' => 'post_receive_hooks#receive'
  get '/tickets_in_play/:repo/:from_sha/:until_sha' => 'tickets_in_play#index'
  root 'issues#index'
end
