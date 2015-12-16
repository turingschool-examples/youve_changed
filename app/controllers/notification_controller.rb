class NotificationController < ApplicationController
  def create
    FriendNotifier.inform(current_user, params[:email]).deliver_later
    flash[:notice] = "Successfully told your friend that they're becoming a worse human being."
    redirect_to root_url
  end
end