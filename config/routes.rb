Rails.application.routes.draw do
  namespace :admin do
    resources :db_uploads
    resources :orders, only: [:index, :altisource_report] do
      collection do
        get :altisource_report
      end
    end
  end
end
