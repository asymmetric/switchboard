# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def active_nav(link)
    return "active" if link.match(/^#{Regexp.escape(request.path)}$/i)
  end

  def show_spinner(id)
    "$('%s').show();" % id
  end

  def hide_spinner(id)
    "$('%s').hide();" % id
  end

  def prettify_ajax_errors(objects=[])
    html = '<ul>'
    objects.each do |obj|
      obj.errors.full_messages.each do |msg|
        html << '<li>'+msg+'</li>'
      end
    end
    html << '</ul>'
  end

  def link_to_remote_with_icon(icon, html_options={})
    image_tag("icons/16/#{icon}", html_options)
  end

end
