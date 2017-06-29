require 'test_helper'

class ControlPalletMailerTest < ActionMailer::TestCase
  test "notification_pallets" do
    mail = ControlPalletMailer.notification_pallets
    assert_equal "Notification pallets", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
