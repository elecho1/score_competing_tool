module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    html = ""
    html += <<-BOF1
    <div class="alert alert-danger alert-dismissible" role="alert">
    BOF1

    sentence = I18n.t("errors.messages.not_saved", count: resource.errors.count, resource: I18n.t("attributes.#{resource.class.model_name.i18n_key}"))

    html += <<-BOF2
      #{sentence}
      <ul>
    BOF2
    
    messages = resource.errors.full_messages.each do |errmsg|
      #html += <<-EOF
      #<div class="alert alert-danger alert-dismissible" role="alert">
      #  <button type="button" class="close" data-dismiss="alert">
      #    <span aria-hidden="true">&times;</span>
      #    <span class="sr-only">close</span>
      #  </button>
      #  #{errmsg}
      #</div>
      #EOF
      html += <<-IOF
          <li>#{errmsg}</li>
      IOF
    end
    html += <<-EOF
      </ul>
    </div>
    EOF
    html.html_safe
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

  def devise_error_one(key)
    return "" until resource.errors.messages[key]
    
    html = ""
    html += <<-BOF
    <div class="alert alert-danger alert-dismissible" role="alert">
    BOF

    resource.errors.messages[key].each do |msg|
      html += <<-IOF
        <div>#{I18n.t("attributes.#{key}")}#{msg}</div>
      IOF
    end
    html += <<-EOF
    </div>
    EOF
    
    html.html_safe

  end
  
end