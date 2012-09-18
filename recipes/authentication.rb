# authentication
if yes?("Would you like to add user authentication?")
  gem("devise", "~> 2.1.2")

   # ask what attributes:datatypes to add to user model
   # in format [attribute]:[data type]:[optional index/unique]
   # add template for scaffold generator based on nifty generator's
   # see http://railscasts.com/episodes/218-making-generators-in-rails-3?view=asciicast
   # http://guides.rubyonrails.org/generators.html#customizing-your-workflow
   # https://github.com/giuseb/nifty-generators/tree/master/rails_generators/nifty_scaffold/templates/actions
   # I think for now I'm going to add all 7 RESTful actions to the template
   # and either delete the unused one's dynamically or have the developer do so... 

  run "rails g resource user email password_digest"

  # get user pages integration tests
  get "https://raw.github.com/BenU/rails-templates/master/spec/requests/user_pages_spec.rb", 
  "spec/requests/user_pages_spec.rb"

  # ***** Add click_link "Sign up now!" integration test to end of layout links specs 
  # on static_pages integration tests

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