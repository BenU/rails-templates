# in config/environments/development.rb add:
  # part of configuration for using Sendgrid on Heroku
  # I moved this from config/environment.rb
  ActionMailer::Base.delivery_method = :test
# before end

# in config/environments/production.rb add:
  # part of configuration for using Sendgrid on Heroku
  # I moved this from config/environment.rb
  ActionMailer::Base.delivery_method = :smtp
# before end