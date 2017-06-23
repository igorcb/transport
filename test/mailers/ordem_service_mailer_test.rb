require 'test_helper'

class OrdemServiceMailerTest < ActionMailer::TestCase
  test "notification_delivery" do
    mail = OrdemServiceMailer.notification_delivery
    assert_equal "Notification delivery", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
