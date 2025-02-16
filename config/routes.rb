Rails.application.routes.draw do
  # See `config/routes/*.rb` to customize these configurations.
  draw "concerns"
  draw "devise"
  draw "sidekiq"
  draw "avo"

  # `collection_actions` is automatically super scaffolded to your routes file when creating certain objects.
  # This is helpful to have around when working with shallow routes and complicated model namespacing. We don't use this
  # by default, but sometimes Super Scaffolding will generate routes that use this for `only` and `except` options.
  collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment

  # This helps mark `resources` definitions below as not actually defining the routes for a given resource, but just
  # making it possible for developers to extend definitions that are already defined by the `bullet_train` Ruby gem.
  # TODO Would love to get this out of the application routes file.
  extending = {only: []}

  scope module: "public" do
    # To keep things organized, we put non-authenticated controllers in the `Public::` namespace.
    # The root `/` path is routed to `Public::HomeController#index` by default.
    get 'public_reservation' => 'home#public_reservation', as: 'public_reservation'
    post 'new_public_reservation' => 'home#new_public_reservation', as: 'new_public_reservation'
    patch 'new_public_reservation' => 'home#new_public_reservation', as: 'edit_public_reservation'
    get 'destroy_reservation' => 'home#destroy_reservation', as: 'destroy_reservation' 
    get '/game_show/:color' => 'home#game_show', as: 'game_show'
    get '/waiver/:retreat' => 'home#waiver', as: 'waiver'
    post 'waiver/create_public_waiver', to: 'home#create_public_waiver', as: 'create_public_waiver'
    get 'thank_you' => 'home#thank_you', as: 'thank_you'
    get 'retreats_json_api/' => 'home#retreats_json_api', as: 'retreats_json_api'
    get 'reservations_json_api/' => 'home#reservations_json_api', as: 'reservations_json_api'
    # Standalone routes for public medform actions
  #get 'medform/new', to: 'medform#new_public', as: :new_public_medform

    # The root `/` path is routed to `Public::HomeController#index` by default. You can set it
    # to whatever you want by doing something like this:
    # root to: "my_new_root_controller#index"
  end

  namespace :webhooks do
    namespace :incoming do
      resources :camp_dashboard_webhooks
      resources :jotform_webhooks
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth provider webhooks above this line.
      end
    end
  end

  namespace :api do
    draw "api/v1"
    # 🚅 super scaffolding will insert new api versions above this line.
  end

  namespace :account do
    shallow do
      # The account root `/` path is routed to `Account::Dashboard#index` by default. You can set it
      # to whatever you want by doing something like this:
      # root to: "some_other_root_controller#index", as: "dashboard"

      # user-level onboarding tasks.
      namespace :onboarding do
        # routes for standard onboarding steps are configured in the `bullet_train` gem, but you can add more here.
      end

      # user specific resources.
      resources :users, extending do
        namespace :oauth do
          # 🚅 super scaffolding will insert new oauth providers above this line.
        end

        # routes for standard user actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      # team-level resources.
      resources :teams, extending do
        # routes for many teams actions and resources are configured in the `bullet_train` gem, but you can add more here.

        # add your resources here.

        resources :invitations, extending do
          # routes for standard invitation actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        resources :memberships, extending do
          # routes for standard membership actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        namespace :integrations do
          # 🚅 super scaffolding will insert new integration installations above this line.
        end

        put 'toggle_flightcheck', to: 'flights#toggle_flightcheck', as: :toggle_flightcheck
        get 'create_seasonal_reservations' => 'reservations#create_seasonal_reservations', as: 'create_seasonal_reservations'
        get 'remove_seasonal_reservations' => 'reservations#remove_seasonal_reservations', as: 'remove_seasonal_reservations'
        patch 'fullcalendar_update/', to: 'reservations#fullcalendar_update', as: :fullcalendar_update
        patch '/account/:team_id/fullcalendar_update', to: 'account/teams#update_fullcalendar_event', as: 'account_team_fullcalendar_update'
        get 'print_retreat' => 'retreats#print', as: 'print_retreat'
        get 'print_gold' => 'retreats#gold', as: 'print_gold'
        get 'calendar' => 'retreats#calendar', as: 'calendar'
        get 'daily_counts' => 'retreats#daily_counts', as: 'daily_counts'
        get '/lodging' => 'items#lodging', as: 'lodging'
        get '/cleaning' => 'items#cleaning', as: 'cleaning'
        get 'schedule_json' => 'reservations#schedule_json', as: 'schedule_json'
        get 'calendar_json' => 'reservations#calendar_json', as: 'calendar_json'
        get 'retreat_calendar_json' => 'retreats#calendar_json', as: 'retreat_calendar_json'
        get 'daily_counts_json' => 'retreats#daily_counts_json', as: 'daily_counts_json'
        get 'mark_notification_read' => 'notifications#mark_notification_read', as: 'mark_notification_read'
        patch '/reservations/:item_id/toggle_clean', to: 'reservations#toggle_clean', as: 'toggle_clean_item'

        resources :demographics, concerns: [:sortable]
        resources :departments, concerns: [:sortable]
        resources :locations, concerns: [:sortable]
        resources :items do
          scope module: 'items' do
            resources :options, only: collection_actions, concerns: [:sortable]
          end
        end
        resources :organizations
        resources :retreats do
          scope module: 'retreats' do
            resources :comments, only: collection_actions
          end
          member do
            get :department_view
            get :kitchen
          end
        end
        resources :reservations do
          patch 'update_planned_date'
        end
        namespace :items do
          resources :tags
          resources :options, except: collection_actions, concerns: [:sortable]
          resources :areas, concerns: [:sortable]
        end

        resources :flights, concerns: [:sortable]
        namespace :flights do
          resources :timeframes, concerns: [:sortable]
          resources :checks
        end

        namespace :organizations do
          resources :contacts
        end

        namespace :retreats do
          resources :comments, except: collection_actions
          resources :requests
        end

        resources :notifications
        namespace :notifications do
          resources :flags
          resources :requests
          resources :archive_actions do
            member do
              post 'approve'
            end
            member do
              post 'approve'
            end
          end

          resources :archive_actions
        end

        resources :seasons
        resources :questions, concerns: [:sortable]
        resources :websiteimages
        resources :games
        resources :medforms
        resources :diets, concerns: [:sortable]
      end
    end
  end
end
