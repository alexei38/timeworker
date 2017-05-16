module ApplicationHelper

  BOOTSTRAP_FLASH_MSG = {
    'success' => 'alert-success',
    'error' => 'alert-error',
    'alert' => 'alert-danger',
    'notice' => 'alert-info'
  }

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_MSG.fetch(flash_type, flash_type.to_s)
  end

  def menu_logged_items
    html = []
    html.append(content_tag(:li) do
      link_to 'TimeWorker', root_path
    end)
    if current_user.admin?
      html.append(content_tag(:li) do
        link_to "Администрирование", admin_index_path
      end)
    end
    html.append(content_tag(:li) do
      link_to current_user.fio, edit_user_registration_path(current_user)
    end)
    html.append(content_tag(:li) do
      link_to "Выход", destroy_user_session_path, :method => :delete
    end)
    return html.join().html_safe
  end

  def menu_builder
    if params[:controller].to_s == 'devise/registrations'
      if params[:action].to_s.in? ['new', 'create']
        #При Регистрации
        concat(content_tag(:li) do
          link_to 'TimeWorker', root_path
        end)
        concat(content_tag(:li) do
          link_to "Авторизация", new_user_session_path 
        end)
        return
      end
      if params[:action].to_s.in? ['edit', 'update']
        #При настройке профиля
        return menu_logged_items
      end
    end
    if params[:controller].to_s == 'devise/sessions'
      #При авторизации
      concat(content_tag(:li) do
        link_to 'TimeWorker', root_path
      end)
      concat(content_tag(:li) do
        link_to "Регистрация", new_user_registration_path
      end)
      return
    end
    unless params[:controller].to_s.in? ['devise/registrations', 'devise/sessions']
      #Для авторизированных пользователей
      return menu_logged_items
    end
  end

end

