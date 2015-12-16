##Prerequisites##

This setup is dependent on Mandrill as an email service. You can plug in your credentials into `config/application.rb`.

Make sure you have redis running.

Don't forget to start sidekiq using: `bundle exec sidekiq -q default -q mailers`

Start your rails server.

If you want to the Sidekiq view, checkout `http://localhost:3000/sidekiq`.
