# main rails template with all component parts

# set up private rvm gemset
if yes?("Set up private rvm gemset for this app?")
  apply "~/programing/rails/rails-templates/recipes/rvm.rb"
end

# add my default gemfiles
apply "~/programing/rails/rails-templates/recipes/gemfile.rb"

# create new README.markdown
apply "~/programing/rails/rails-templates/recipes/readme.rb"

# initiate git, update .gitignore and first commit
apply "~/programing/rails/rails-templates/recipes/git.rb"

# update default css and view layout files and partials
apply "~/programing/rails/rails-templates/recipes/views.rb"

# ***** Add the following to recipes/views.rb
# collect from HTML5Boilerplate (in addition to normalize.css)
# - IE PNG fixes to make CSS image resizeing work in IE
# - a clearfix to help with issues related to floated elements

# add rspec, spork and capybara
apply "~/programing/rails/rails-templates/recipes/rspec.rb"

# set up database for postgreSQL
apply "~/programing/rails/rails-templates/recipes/postgresql.rb"

# static pages
apply "~/programing/rails/rails-templates/recipes/static_pages.rb"

# logo -- add or use placeholder
apply "~/programing/rails/rails-templates/recipes/logo.rb"
  
# authentication
apply "~/programing/rails/rails-templates/recipes/authentication.rb"

# deployment -- github and heroku
apply "~/programing/rails/rails-templates/recipes/deployment.rb"