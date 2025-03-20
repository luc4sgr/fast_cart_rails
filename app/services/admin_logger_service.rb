class AdminLoggerService
    def self.log(admin, action, details)
      AdminLog.create!(
        admin_id: admin.id,  # <- Aqui estava o erro! Agora usamos admin_id
        action: action,
        details: details
      )
    end
end
