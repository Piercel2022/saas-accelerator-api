require "test_helper"

class OrganizationNotificationMailerTest < ActionMailer::TestCase
  test "member_invited" do
    mail = OrganizationNotificationMailer.member_invited
    assert_equal "Member invited", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "member_joined" do
    mail = OrganizationNotificationMailer.member_joined
    assert_equal "Member joined", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "subscription_changed" do
    mail = OrganizationNotificationMailer.subscription_changed
    assert_equal "Subscription changed", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
