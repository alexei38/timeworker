module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?
    html = []
    resource.errors.full_messages.each do |msg|
      html.append('<div class="alert alert-danger alert-block">')
      html.append('<button type="button" class="close" data-dismiss="alert">x</button>')
      html.append(msg)
      html.append('</div>')
    end
    html.join().html_safe
  end

  def devise_error_messages_for(resource)
    return "" if resource.errors.empty?
    html = []
    resource.errors.full_messages.each do |msg|
      html.append('<div class="alert alert-danger alert-block">')
      html.append('<button type="button" class="close" data-dismiss="alert">x</button>')
      html.append(msg)
      html.append('</div>')
    end
    html.join().html_safe
  end

end