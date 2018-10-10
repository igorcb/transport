json.array! @notifications do |notification|
  json.id notification.id
  json.unread !notification.read_at?
  #json.template render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification}, formats: [:html]

  #json.recipient notification.recipient
  json.actor notification.actor.email
  json.action notification.action
  json.notifiable do
    json.name "#{notification.notifiable.name}"
    json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
  end
  json.url task_path(notification.notifiable)

end