# main rails template with all component parts

# add my default gemfiles
apply "~/programing/rails/rails-templates/recipes/gemfile.rb"

# initiate git, update .gitignore and first commit
apply "~/programing/rails/rails-templates/recipes/git.rb"

# set up database for postgreSQL
apply "~/programing/rails/rails-templates/recipes/postgresql.rb"

# add rspec, spork and capybara
apply "~/programing/rails/rails-templates/recipes/rspec.rb"

# authentication
apply "~/programing/rails/rails-templates/recipes/authentication.rb"