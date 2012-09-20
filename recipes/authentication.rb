# authentication
if yes?("Would you like to add user authentication?")
  @authentication = true
  gem("devise", "~> 2.1.2")
  run 'bundle install'
  run 'rails generate devise:install'

  run 'subl config/initializers/devise.rb'

  until yes?("Have you reviewed the devise initializer, updating the `mailer_sender?`")
  end

  # change this to gsub since more than one 'end' ****** 
  gsub_file "config/environments/development.rb", /\nend/,
    "\n  config.action_mailer.default_url_options = { :host => '0.0.0.0:5000' }\nend"

  gsub_file "config/environments/production.rb", /\nend/,
    "\n  config.action_mailer.default_url_options = { :host => 'www.myappdomain.com' }\nend"

  unless @static_pages
    insert_into_file "config/routes.rb",
      "\n  root :to => \"public/index.html\"\n",
      after: "::Application.routes.draw do"
  end

  user_attributes = ask("What attributes would you like for your user model? [field[:type][:index/unique]]")
  puts "#{user_attributes}"
  generate "model", "User #{user_attributes}"
  # generate attributes based specs for user model

  # generate user model
  rake "db:migrate"
  rake "db:test:prepare"
  run 'rails generate devise User'
  rake "db:migrate"
  rake "db:test:prepare"

=begin

  # generate integration tests for user pages based on model attributes
  # ***** Add click_link "Sign up now!" integration test to end of layout links specs 
  # on static_pages integration tests

  # generate user controller, routes and views

  # get user pages integration tests
  get "https://raw.github.com/BenU/rails-templates/master/spec/requests/user_pages_spec.rb", 
  "spec/requests/user_pages_spec.rb"


  # annotate the user model
  run "annotate --position before"
  
  # git commit
  git add: "."
  git commit: "-am 'Add user and basic authentication'"
=end
end
