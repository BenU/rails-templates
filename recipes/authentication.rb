# authentication
if yes?("Would you like to add user authentication?")
  run "rails g resource user email password_digest"

  # get user pages integration tests
  get "https://raw.github.com/BenU/rails-templates/master/spec/requests/user_pages_spec.rb", 
  "spec/requests/user_pages_spec.rb"

  # Uncomment "# gem 'bcrypt-ruby'" in gemfile
  gsub_file "Gemfile", /# gem 'bcrypt-ruby', /, "gem 'bcrypt-ruby',"
  run "bundle install"
  
  # update user model
  remove_file "app/models/user.rb"
  get "https://raw.github.com/BenU/rails-templates/master/app/models/user.rb",
  "app/models/user.rb"
  rake "db:migrate"

  # add index to users email
  generate "migration add_index_to_users_email"
  # modify "db/migrate/[timestamp]_add_index_to_users_email.rb"
  # trying to follow info found here: http://stackoverflow.com/questions/7690003/how-do-i-get-a-rails-template-to-add-additional-attributes-on-migration-columns
  # the following two lines of code is an ugly hack since how 'Dir' works
  # isn't completely clear to me
  index_migration_array = Dir['db/migrate/*_add_index_to_users_email.rb']
  index_migration_file = index_migration_array.first
  in_root { insert_into_file index_migration_file, 
  "\n    add_index :users, :email, unique: true", after: "change" }
  rake "db:migrate"

  # create/update test database
  rake "db:test:prepare"

  # udpate model specs
  remove_file "spec/models/user_spec.rb"
  get "https://raw.github.com/BenU/rails-templates/master/spec/models/user_spec.rb",
  "spec/models/user_spec.rb" 


  # update user controller, views and integration tests
  apply "https://raw.github.com/BenU/rails-templates/master/recipes/user_vc.rb"

  # annotate the user model
  run "annotate --position before"
  
  # git commit
  git add: "."
  git commit: "-am 'Add user and basic authentication'"
end