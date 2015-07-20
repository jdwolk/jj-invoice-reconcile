Rails.application.routes.draw do
  namespace :admin do
    resources :orders
    resource :reconciliation, controller: 'reconciliation'
  end
end
