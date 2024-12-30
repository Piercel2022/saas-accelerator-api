class OrganizationNotificationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.organization_notification_mailer.member_invited.subject
  #
  def member_invited
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.organization_notification_mailer.member_joined.subject
  #
  def member_joined
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.organization_notification_mailer.subscription_changed.subject
  #
  def subscription_changed
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
