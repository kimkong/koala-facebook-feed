module FeedHelper

  def display_message entry
    entry = YAML::load entry
    entry['message']
  end

  def display_entry entry
    output = ""
    entry = YAML::load entry

    case entry['status_type']
    when "added_photos"
      output += entry_header entry
      output += "<div class='message'> #{simple_format( auto_link(entry['message']) )} </div>"

      output += "<div class='caption'> #{entry['name']} <span class='muted'> (#{entry['link'].split('=').last} photos) </span> </div>"
      output += "<a href='#{entry['link']}' target='_blank'> "
      output += "<center>"
      output += image_tag "https://sphotos-a.xx.fbcdn.net/hphotos-ash3/" + entry["picture"].split('/').last.gsub(/s/, 'n')
      output += "</center>"
      output += "</a>"
      output += like_block entry
      output += comment_block entry
      output += "</div>"


    when "shared_story"
      output += entry_header entry
      output += "<div class='message'> #{simple_format( auto_link(entry['message']) )} </div>"
      output += media_block entry
      output += like_block entry
      output += comment_block entry
      output += "</div>"

    when "mobile_status_update", "wall_post"
      output += entry_header entry
      output += "<div class='message'> #{simple_format( auto_link(entry['message']) )} </div>"
      output += "<div class='message'> #{entry['story']} </div>"
      output += like_block entry
      output += comment_block entry
      output += "</div>"
    end
  end





  def entry_header entry
    output =  "<div class='feed_entry'>"
    output += "<div class='post_info'>"
    output += "#{entry['from']['name']}"
    if entry['status_type'] == "added_photos"
      output += "<span class='muted'> posted a </span>"
      output += %Q|<a href="#{entry['link']}" target:'_blank'>photo. </a>|
    elsif entry['type'] == 'link'
      output += "<span class='muted'> shared a </span>"
      output += %Q|<a href="#{entry['link']}" target:'_blank'>link. </a>|
    elsif entry['type'] == 'photo'
      output += "<span class='muted'> shared a photo</span>"
    end
    output += %Q|<div class='pull-right post_date muted'> #{time_ago_in_words entry['created_time']} ago </div>|
    output += "</div>"

    # for debugging to verify entry_type to status_type combinations
    # output += "<div class='text-right'> <span class='label'> #{entry['status_type']} #{entry['type']} </span> </div>"
  end

  def like_block entry
    output = "<div class='like_block'> "
    if entry['actions'] && entry['actions'][0] && entry['actions'][0]['link']
      if entry['likes'] && entry['likes']['count'] && (entry['likes']['count'] > 0)
        output += "<div class='pull-right muted'> #{pluralize entry['likes']['count'], 'person likes', 'people like'} this </div>"
      end
      output += %Q|<a href="#{entry['actions'][0]['link']}" target="_blank"> comment </a>|
      output += %Q|<a href="#{entry['actions'][0]['link']}" target="_blank"> like </a>|
    end
    output += "</div>"
  end


  def comment_block entry
    output = "<div class='comment_block'> "
    if entry['comments']['count'] > 0
      entry['comments']['data'].each do |comment|
        output += "<div class='comment'> <span class='author'> #{comment['from']['name']} </span> <span class='message'>  #{comment['message']} </span> </div>"
      end
    end
    output += "</div>"
  end


  def media_block entry
    output = "something got messed up"
    case entry['type']
    when 'photo'
      output =  "<div class='caption'> #{entry['caption']} </div>"
      output += "<center>"
      output += "<a href='#{entry['link']}' target='_blank'> "
      output += image_tag "https://sphotos-a.xx.fbcdn.net/hphotos-ash3/" + entry["picture"].split('/').last.gsub(/s/, 'n')
      output += "</center>"
      output += "</a>"

    when 'video'
      output =  "<table class='video'><tr>"
      output += "<td class='thumb'>"
      output += "<a href='#mediaModal' target='_blank' class='video thumb' data-toggle='modal' data-title='#{entry['name']}' data-embed='#{entry['source']}'> "
      output += image_tag "#{entry['picture']}"
      output += "<i class='icon-play-circle'></i>"
      output += "</a>"
      output += "</td>"

      output += "<td><div class='gutter left'>"
      output += "<div class='title'>"
      output += "<a href='#{entry['link']}' target='_blank'>#{entry['name']}</a></div> "
      output += "<div class='caption'>#{entry['caption']}</div>"
      output += "<div class='description'>#{entry['description']}</div>"

      output += "</div></td>"
      output += "</tr></table>"

    when 'link', 'music'
      output =  "<table class='link'><tr>"
      if entry['picture']
        output += "<td class='thumb'>"
        output += "<a href='entry['link']' target='_blank'> "
        output += image_tag "#{entry['picture']}"
        output += "</a>"
        output += "</td>"
      end
      output += "<td><div class='gutter left'>"
      output += "<div class='title'>"
      output += "<a href='#{entry['link']}' target='_blank'>#{entry['name']}</a></div> "
      output += "<div class='caption'>#{entry['caption']}</div>"
      output += "<div class='description'>#{entry['description']}</div>"

      output += "</div></td>"
      output += "</tr></table>"

    end
    output
  end


end

