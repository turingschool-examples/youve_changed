class NotificationsController < ApplicationController
  def create
    FriendNotifierMailer.inform(current_user, params[:email]).deliver_now

    flash[:notice] = "Successfully told your firend that they've changed"

    redirect_to root_url
  end
end
