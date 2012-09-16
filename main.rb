# main rails template with all component parts

# set up private rvm gemset
if yes?("Set up private rvm gemset for this app?")
  apply "https://raw.github.com/BenU/rails-templates/master/recipes/rvm.rb"
end

# add my default gemfiles
apply "https://raw.github.com/BenU/rails-templates/master/recipes/gemfile.rb"

# create new README.markdown
apply "https://raw.github.com/BenU/rails-templates/master/recipes/readme.rb"

# initiate git, update .gitignore and first commit
apply "https://raw.github.com/BenU/rails-templates/master/recipes/git.rb"

# update default css and view layout files and partials
apply "https://raw.github.com/BenU/rails-templates/master/recipes/views.rb"

# ***** Add the following to recipes/views.rb
# collect from HTML5Boilerplate (in addition to normalize.css)
# - IE PNG fixes to make CSS image resizeing work in IE
# - a clearfix to help with issues related to floated elements

# add rspec, spork and capybara
apply "https://raw.github.com/BenU/rails-templates/master/recipes/rspec.rb"

# set up database for postgreSQL
apply "https://raw.github.com/BenU/rails-templates/master/recipes/postgresql.rb"

# static pages
apply "https://raw.github.com/BenU/rails-templates/master/recipes/static_pages.rb"

# logo -- add or use placeholder
apply "https://raw.github.com/BenU/rails-templates/master/recipes/logo.rb"

# **** this recipe is not done yet.  Lacks sessions, etc.  
# authentication
apply "https://raw.github.com/BenU/rails-templates/master/recipes/authentication.rb"

# deployment -- github and heroku
apply "https://raw.github.com/BenU/rails-templates/master/recipes/deployment.rb"