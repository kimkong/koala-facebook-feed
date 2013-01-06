KoalaFacebookFeed::Application.routes.draw do

  root :to => 'home#index'

  %w(update_feed).each do |page|
    get page, controller: "home", action: page
  end

end
