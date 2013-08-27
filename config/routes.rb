EverydayHeroHub::Application.routes.draw do
  post '/receive' => 'post_receive_hooks#receive'
  root 'issues#index'
end
