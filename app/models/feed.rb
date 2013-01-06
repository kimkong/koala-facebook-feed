class Feed < ActiveRecord::Base
  attr_accessible :entry, :entry_id, :entry_type, :status_type, :created_at

  def self.update_feed
    key = ENV['APP_ID'] or raise('ENV not set!!')
    secret = ENV['APP_SECRET'] or raise('ENV not set!!')
    page_name = "FACEBOOK_PAGENAME"
    callback_url = "http://127.0.0.1:3000"


    oauth = Koala::Facebook::OAuth.new(key, secret, callback_url)
    oauth_access_token = oauth.get_app_access_token
    @graph = Koala::Facebook::API.new(oauth_access_token)

    feed = @graph.get_connections(page_name, "feed")

    add_entries(feed.entries)
  end


  def self.add_entries entries
    entries.each do |entry|
      unless exists? :entry_id => entry['id']
        Feed.create(  :entry => YAML::dump(entry),
                      :entry_id => entry['id'],
                      :status_type => entry['status_type'],
                      :entry_type => entry['type'],
                      :created_at => entry['created_time'].to_time )
      end
    end
  end

end
