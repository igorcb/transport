require 'test_helper'

class NfeKeyMailerTest < ActionMailer::TestCase
  test "request_receipt" do
    mail = NfeKeyMailer.request_receipt
    assert_equal "Request receipt", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
