EverydayHeroHub::Application.routes.draw do
  post '/receive' => 'post_receive_hooks#receive'
  get '/issues_in_action' => 'issues_in_action#index'
  root 'issues#index'
end
