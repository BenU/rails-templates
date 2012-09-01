# authentication
if yes?("Would you like to add user authentication?")
  run "rails g resource user email password_digest"
  
  # update user model
  remove_file "app/models/user.rb"
  get "https://raw.github.com/BenU/rails-templates/master/app/models/user.rb",
  "app/models/user.rb"
  rake "db:migrate"

  # create/update test database
  rake "db:test:prepare"

  # udpate model specs
  remove_file "spec/models/user_spec.rb"
  get "https://raw.github.com/BenU/rails-templates/master/spec/models/user_spec.rb",
  "spec/models/user_spec.rb" 


  # update user controller
  # substitute in app/controllers/users_controller.rb
  remove_file "app/controllers/users_controller.rb"
  get "https://raw.github.com/BenU/rails-templates/master/app/controllers/users_controller.rb",
  "app/controllers/users_controller.rb"
  
  # update app/views/users/new.html.erb
  remove_file "app/views/users/new.html.erb"
  get "https://raw.github.com/BenU/rails-templates/master/app/views/users/new.html.erb",
  "app/views/users/new.html.erb"
  
  # Uncomment "# gem 'bcrypt-ruby'" in gemfile
  gsub_file "Gemfile", /# gem 'bcrypt-ruby', /, "gem 'bcrypt-ruby',"
  run "bundle install"
  run "annotate --position before"
  
  # git commit
  git add: "."
  git commit: "-am 'Add user model and basic authentication'"
end