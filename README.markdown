##Sending Email with the service Sendgrid##

###Getting Started###

If you don't already have one, the first step you should do is sign up for an account with Sendgrid. It would be best to do this ahead of time. Sendgrid with provision your account at first so it might take some time to get the account set up. You should sign up for the free account.

Now that we've got that, go ahead and clone down the repo

```shell
git clone https://github.com/tessgriffin/youve_changed.git youve_changed
```

###Figaro###

Our next step will be to set up Figaro. It is a gem that let's us set up ruby environment variables for things like keys (or that Sendgrid username and password you just set up)

```rb
  # Gemfile
  gem "figaro"
```
And after you bundle, run

```shell
  bundle exec figaro install
```

This creates an application.yml file and adds it to your .gitignore

For now, let's put our Sendgrid username and password into the newly created application.yml file

```rb
# config/application.yml

SENDGRID_USER_NAME: "supersecret"
SENDGRID_PASSWORD: "supersecretpassword"
```

And remember, don't add the application.yml to your commits! We never push up our keys to Github.

##Creating the Mailer##

Our next step will be to create the Friend mailer to passive-aggressively inform your friends that they've changed.

```shell
rails g mailer FriendNotifier
```

This creates a lot of files for you. Let's first start out with the FriendNotifier.

```rb
# mailers/friend_notifier.rb

class FriendNotifier < ApplicationMailer
  def inform(user, friend_contact)
    @user = user
    mail(to: friend_contact, subject: "#{user.name} says you've changed.")
  end
end
```
Next we'll make the views that will determine the body of the email that is send.

In app/views/friend_notifier create two files, inform.html.erb and inform.text.erb

Depending on the person's email client you're sending the email to, it will render either the plain text or the html view. We don't have control over that, so we'll make them have the same content.

```rb
# inform.html.erb and inform.text.erb

Your 'friend' <%= @user.name.capitalize %> wanted to let you know that you've changed. Tell someone else that they've changed. It's your duty.
```

##Notification Controller##

Next we'll make a new controller that will call our mailer. Create a controller called NotificationController

```rb
# app/controllers/notification_controller.rb

class NotificationController < ApplicationController
  def create
    FriendNotifier.inform(current_user, params[:email]).deliver_later
    flash[:notice] = "Successfully told your friend that they've changed."
    redirect_to root_url
  end
end
```

We'll also make sure we put that route into the routes file:

```rb
post '/notification' => 'notification#create'
```
##Putting it all together##

Remember that setup we did earlier with Sendgrid? Now let's plug it into our program.

First, let's change the default address the email gets sent from:

```rb
class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@youvechanged.io"
  layout 'mailer'
end
```

And now in config/application.rb:

```rb
module YouveChanged
  class Application < Rails::Application
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      address:              'smtp.sendgrid.net',
      port:                 '587',
      domain:               'example.com',
      user_name:            ENV["SENDGRID_USER_NAME"],
      password:             ENV["SENDGRID_PASSWORD"],
      authentication:       'plain',
      enable_starttls_auto: true
    }
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
```

This is where figaro comes in handy. Just make sure that the ENV variables that you set here match the ones in your application.yml file that figaro generated for you.

