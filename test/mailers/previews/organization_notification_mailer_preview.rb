# Preview all emails at http://localhost:3000/rails/mailers/organization_notification_mailer
class OrganizationNotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/organization_notification_mailer/member_invited
  def member_invited
    OrganizationNotificationMailer.member_invited
  end

  # Preview this email at http://localhost:3000/rails/mailers/organization_notification_mailer/member_joined
  def member_joined
    OrganizationNotificationMailer.member_joined
  end

  # Preview this email at http://localhost:3000/rails/mailers/organization_notification_mailer/subscription_changed
  def subscription_changed
    OrganizationNotificationMailer.subscription_changed
  end
end
