# Rails.application.routes.draw do
#   resources :applications
#   resources :messages
#   resources :chats
# end

Rails.application.routes.draw do
  resources :applications, only: [:create, :update, :show], path: '/applications', param: :token do
    resources :chats, only: [:create, :update, :index, :show], path: '/chats', param: :number do
      resources :messages, only: [:create, :update, :index, :show], path: '/messages', param: :number do
        # collection do
        #   get :search
        # end
      end
    end
  end
end
