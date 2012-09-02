# authentication
if yes?("Would you like to add user authentication?")
  run "rails g resource user email password_digest"
  
  # update user model
  remove_file "app/models/user.rb"
  get "https://raw.github.com/BenU/rails-templates/master/app/models/user.rb",
  "app/models/user.rb"
  rake "db:migrate"

  # add index to users email
  generate "migration add_index_to_users_email"
  # modify "db/migrate/[timestamp]_add_index_to_users_email.rb"
  # trying to follow info found here: http://stackoverflow.com/questions/7690003/how-do-i-get-a-rails-template-to-add-additional-attributes-on-migration-columns
  # in_root { || insert_into_file }
  index_migration = Dir['db/migrate/*_add_index_to_users_email.rb']
  # insert_into_file "index_migration", 
  # "\n  add_index :users, :email, unique: true", after: "change"
  # rake "db:migrate"

  puts index_migration

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