class HomeController < ApplicationController

  def index
    @feed = Feed.order('created_at DESC').limit 5
    @entries = @feed.map {|f| YAML::load(f.entry)}
  end

  def blog
    @feed = Feed.order("created_at desc").paginate(:page => params[:page], :per_page => params[:per_page] || 10 )
  end
  def update_feed
    @pre_pull_id = Feed.last.try :id
    Feed.update_feed
    @post_pull_id = Feed.last.try :id
  end
end





