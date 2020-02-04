class FriendNotifierMailer < ApplicationMailer
  def inform(user, friend_contact)
    @user = user
    mail(to: friend_contact, subject: "#{user.name} says your've changed")
  end
end
