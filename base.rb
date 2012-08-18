# add my default gemfiles
gem("thin", "~> 1.4.1")
gem("will_paginate", "~> 3.0.3")
gem("simple_form", "~> 2.0.2")

gem_group :development do
 gem("annotate", "~> 2.5.0")
 gem("pry", "~> 0.9.10")
end

gem_group :test, :development do
 gem("faker", "~> 1.0.1")
 gem('rspec-rails', '~> 2.11.0')
end

gem_group :test do
 gem("spork", "~> 0.9.2")
 gem('capybara', '~> 1.1.2')
 gem('factory_girl_rails', '~> 4.0.0')
end

# remove default README file
remove_file "README.rdoc"

# create README.markdown
create_file "README.markdown" do
  readme = ask("What do you want in the README.markdown file?")
  "#{readme}"
end

# initiate git, add to .gitignore, add files and commit
git :init
append_file ".gitignore" do 
"
# Ignore other unneeded files.
doc/
*.swp
*~
.project
.DS_Store"
end
git :add => "."
git :commit => "-m 'First commit!'"

# create Procfile for heroku deployment
create_file "Procfile", "web: bundle exec rails server thin -p $PORT -e $RACK_ENV"

# Per heroku instructions 'Getting Started with Rails 3.x on Heroku at
# https://devcenter.heroku.com/articles/rails3
# Set the RACK_ENV to development in your environment
run('echo "RACK_ENV=development" >>.env')

git :add => "."
git :commit => "-m 'use thin via procfile'"


# replace default app/views/application.html.erb file 
# with my default
# Note: at some point could make tytle dynamic with app's name...
remove_file "app/views/layouts/application.html.erb"
get "https://raw.github.com/BenU/rails-templates/master/app/views/layouts/application.html.erb?login=BenU&token=9fe3e7a5a988a242aaef451093e81d0e", 
"app/views/layouts/application.html.erb"

# add header partial to project
get "https://raw.github.com/BenU/rails-templates/master/app/views/layouts/_header.html.erb?login=BenU&token=1a0272ce564699fac96ff5363256f7af", 
"app/views/layouts/_header.html.erb"

# add footer partial to project
get "https://raw.github.com/BenU/rails-templates/master/app/views/layouts/_footer.html.erb?login=BenU&token=56a0168e5744af2882b991a42a3c3168", 
"app/views/layouts/_footer.html.erb"

# application.css manifest
# remove *= require_tree so we can load the css files in desired order
# add normalize.css and other default css files to manifest
gsub_file 'app/assets/stylesheets/application.css', /\A*= require_tree ./, 
'= require normalize
 *= require layout' 
# get normalize.css and add to apps/assets/stylesheets/
get 'https://raw.github.com/necolas/normalize.css/master/normalize.css', 
'app/assets/stylesheets/normalize.css'
# get default layout.css and add to apps/assets/stylesheets/
get 'https://raw.github.com/BenU/rails-templates/master/app/assets/stylesheets/layout.css.scss?login=BenU&token=30896367cf073355fa8d08a9e1b7c22d', 
'app/assets/stylesheets/layout.css.scss'


# modernizr.js
# Add uncompressed modernizr.js development file 
# and add to apps/assets/javascrips/
# add modernizr.js to application.js manifest
# NB: a minimized, modernizr file can/should be subbed in
# later when the needed js is established
get "http://modernizr.com/downloads/modernizr.js", 
"app/assets/javascripts/modernizr.development.js"
gsub_file "app/assets/javascripts/application.js", 
/require jquery[^_]/, 
'require modernizr.development
//= require jquery
'

git :add => "."
git :commit => "-m 'Add normalize.css, default layout.css.scss and modernizr.development'"

# collect from HTML5Boilerplate (in addition to normalize.css)
# - IE PNG fixes to make CSS image resizeing work in IE
# - a clearfix to help with issues related to floated elements

# Create static_pages controller with home action
# create root_to static_pages#home in routes
