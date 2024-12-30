require "test_helper"

class UserNotificationMailerTest < ActionMailer::TestCase
  test "welcome" do
    mail = UserNotificationMailer.welcome
    assert_equal "Welcome", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "subscription_update" do
    mail = UserNotificationMailer.subscription_update
    assert_equal "Subscription update", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "password_reset" do
    mail = UserNotificationMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
