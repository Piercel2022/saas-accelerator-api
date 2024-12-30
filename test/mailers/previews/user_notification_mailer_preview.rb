# Preview all emails at http://localhost:3000/rails/mailers/user_notification_mailer
class UserNotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_notification_mailer/welcome
  def welcome
    UserNotificationMailer.welcome
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_notification_mailer/subscription_update
  def subscription_update
    UserNotificationMailer.subscription_update
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_notification_mailer/password_reset
  def password_reset
    UserNotificationMailer.password_reset
  end
end
