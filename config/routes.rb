Rails.application.routes.draw do
  namespace :admin do
    resources :orders do
      collection do
        get :altisource_report
      end
    end
    resource :reconciliation, controller: 'reconciliation'
  end
end
