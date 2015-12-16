require 'test_helper'

class FriendMailerTest < ActionMailer::TestCase
  def test_it_sends_an_email
    user = User.create(name: 'Changy McChangerson', email: 'changy@example.com')
    FriendMailer.inform(user, 'test@example.com').deliver_now
    result = ActionMailer::Base.deliveries.last

    assert result
    assert result.to.include? "test@example.com"
    assert_equal "Changy McChangerson says you've changed.", result.subject
  end
end
