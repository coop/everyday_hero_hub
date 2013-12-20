EverydayHeroHub::Application.routes.draw do
  post '/receive' => 'post_receive_hooks#receive'
  get '/tickets_in_play' => 'tickets_in_play#index'
  root 'issues#index'
end
