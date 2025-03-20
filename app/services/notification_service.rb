class NotificationService
    def self.send_notification(user, message)
      Notification.create!(user: user, message: message)
    end
end
