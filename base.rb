# add my default gemfiles
gem("thin", "~> 1.4.1")
gem("will_paginate", "~> 3.0.3")
gem("formtastic", "~> 2.2.1")

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
run 'bundle install'

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
# consider adding config/database.yml to .gitignore
end
git :add => "."
git :commit => "-am 'First commit!'"

# replace default app/views/application.html.erb file 
# with my default
# Note: at some point could make tytle dynamic with app's name...
remove_file "app/views/layouts/application.html.erb"
get "https://raw.github.com/BenU/rails-templates/master/app/views/layouts/application.html.erb", 
"app/views/layouts/application.html.erb"

# add header partial to project
get "https://raw.github.com/BenU/rails-templates/master/app/views/layouts/_header.html.erb", 
"app/views/layouts/_header.html.erb"

# add footer partial to project
get "https://raw.github.com/BenU/rails-templates/master/app/views/layouts/_footer.html.erb", 
"app/views/layouts/_footer.html.erb"

# application.css manifest
# remove *= require_tree so we can load the css files in desired order
# add normalize.css and other default css files to manifest
# **** note that the formtastic edits should be dynamically added should the 
# formtastic gem be used.  Something to refactor.
gsub_file 'app/assets/stylesheets/application.css', /\A*= require_tree ./, 
'= require normalize
 *= require layout
 *= require formtastic
 *= require my_formtastic_changes' 
# get normalize.css and add to apps/assets/stylesheets/
get 'https://raw.github.com/necolas/normalize.css/master/normalize.css', 
'app/assets/stylesheets/normalize.css'
# get default layout.css and add to apps/assets/stylesheets/
get 'https://raw.github.com/BenU/rails-templates/master/app/assets/stylesheets/layout.css.scss', 
'app/assets/stylesheets/layout.css.scss'

# formtastic
run "rails g formtastic:install"
create_file "app/assets/stylesheets/ie6.css", "*= require formtastic_ie6"
create_file "app/assets/stylesheets/ie7.css", "*= require formtastic_ie7"
create_file "app/assets/stylesheets/my_formtastic_changes.css.scss", 
"// Place changes to formtastic default styling here."
insert_into_file "config/environments/production.rb", 
"\n\n  # reqired for formtastic
  config.assets.precompile += %w( ie6.css ie7.css )",
after: "config.assets.digest = true"

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
git :commit => "-am 'Add normalize.css, default layout.css.scss, modernizr.development, formtastic changes'"

# *****
# collect from HTML5Boilerplate (in addition to normalize.css)
# - IE PNG fixes to make CSS image resizeing work in IE
# - a clearfix to help with issues related to floated elements

# rspec
# add code to config/application.rb so that specs aren't 
# generated for controllers, views, helpers and routing
rspec_defaults =
"\n
    # don't generate specs for controllers, views, helpers and routing
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
      g.controller_specs false
      g.routing_specs false
    end
\n"
insert_into_file 'config/application.rb', rspec_defaults, 
after: "class Application < Rails::Application\n"
# run rspec:install generator
generate 'rspec:install'

# Spork http://rubydoc.info/gems/spork/0.9.2/frames
# see `get` solution at: https://github.com/Hack56/Rails-Template
run 'bundle exec spork rspec --bootstrap'

# subsitute spec/spec_helper.rb to accomodate spork (and possibly capybara.)
# The spork changes add all the "environmental loading" spork
# stuff to the `Spork.prefork` block.
# my template spec/spec_helper.rb file created 2012-08-20 [BDU]
# includes a `require 'capybar/rspec'` line that may not be needed
# as well as a commented out `config.mock_with :rspec` that
# may be needed.  But I'll update those as I get more info.
remove_file "spec/spec_helper.rb"
get "https://raw.github.com/BenU/rails-templates/master/spec/spec_helper.rb", 
"spec/spec_helper.rb"

git :add => "."
git :commit => "-am 'Set up for rspec, spork and capybara

Establish rspec defaults
bootstrap spork
update spec/spec_helper.rb for spork 
and add line to same file to require capybara
which may not be necessary.'"


# prepare database.yml for postgreSQL
# code below was taken from ProGNOMmers's gist at:
# https://gist.github.com/2489048
if yes?('Do you want to change the database username setting it to the current Unix username?')
  username = ENV['USER']
  gsub_file 'config/database.yml', /^(  username: ).*$/, '\1%s' % username
  # run %Q(sed -i 's/  username: .*/  username: #{username}/g' config/database.yml)
end
# the code below was inspired (mostly copied) from Daniel Kehoe's great
# rails_apps_composer gems recipe found at:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/gems.rb
puts "Creating a user named '#{app_name}' for PostgreSQL"
run "createuser #{app_name}"
gsub_file "config/database.yml", 
/username: .*/, "username: #{app_name}"
gsub_file "config/database.yml", 
/database: myapp_development/, "database: #{app_name}_development"
gsub_file "config/database.yml", 
/database: myapp_test/,        "database: #{app_name}_test"
gsub_file "config/database.yml", 
/database: myapp_production/,  "database: #{app_name}_production"
# next create development and test databases as described here:
# http://blog.willj.net/2011/05/31/setting-up-postgresql-for-ruby-on-rails-development-on-os-x/
run "createdb -O#{app_name} -Eutf8 #{app_name}_development"
run "createdb -O#{app_name} -Eutf8 #{app_name}_test"
# also, though there is no mention of the need in the above blog post...
# an error message in the postgreSQL log is generated.  Hense the next
# line:
run "createdb -O#{app_name} -Eutf8 #{app_name}_production"

# generate static pages
if yes?("Would you like to generate static pages?")
  static_pages = "home "
  static_pages += ask("In addition to home, what other static pages do you want created?
  Please separate your pages by spaces:")
  generate "controller", "StaticPages #{static_pages}"
  route("root :to => 'static_pages#home'")
  remove_file "public/index.html"

  git :add => "."
  git :commit => "-am 'Create static pages'"

  # generate some integration tests for the static pages
  # which fail... and should be refactored anywhoo.
  puts "generating some static pages integration tests!"
  static_pages_array = static_pages.split()
  stat_pages_integration_tests = 
    "require 'spec_helper'

  describe 'Static Pages' do
    "
  static_pages_array.each do |static_page|
    stat_pages_integration_tests += 
    "
  describe \"#{static_page} page\" do
    it \"should have the content \'#{static_page.capitalize}\'\" do
      visit \'/static_pages/#{static_page}\'
      page.should have_content(\'#{static_page.capitalize}\')
    end
  end
"
  end
    stat_pages_integration_tests += "
end"
  create_file "spec/requests/static_pages_spec.rb", stat_pages_integration_tests

  git :add => "."
  git :commit => "-am 'Create static_pages integration test placeholders.'"  
end
  
# get logo placeholder
if yes?("Do you have a logo image (png formate only) you would like to use?")
  logo_path = ask("What is the path to your logo file?")
else 
  logo_path = "https://raw.github.com/BenU/rails-templates/master/app/assets/images/logo.png"
end
get logo_path, "app/assets/images/logo.png"
git add: "."
git commit: "-am 'Add logo placeholder image or logo image'"


# authentication
if yes?("Would you like to add user authentication?")
  run "rails g resource user email password_digest"
  # update user model
  remove_file "app/models/user.rb"
  get "https://raw.github.com/BenU/rails-templates/master/app/models/user.rb",
  "app/models/user.rb"
  rake "db:migrate"
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
  # git commit
  git add: "."
  git commit: "-am 'Add user model and basic authentication'"
end

# push app to github.com
if yes?("Would you like to store source in GitHub repository?")
  github_username = ask("What is your username on github?")
  run "git remote add origin git@github.com:#{github_username}/#{app_name}.git"
  run "git push -u origin master"

  until (run "git push -u origin master") do
    github_failure_response = yes?("Couldn't push to github.  Need to make the repository there? (y/n)")
    if github_failure_response
      puts "Ok.  Go make the #{app_name} repository at github."
      yes?("Have you made the repository?")
    else
      break
    end
  end

  # don't deploy to heroku of unable to deploy to github so... github_failure_response
  # deploy to heroku?
  if github_failure_response && yes?("Would you like to deploy to Heroku?")
    # create Procfile for heroku deployment
    create_file "Procfile", "web: bundle exec rails server thin -p $PORT -e $RACK_ENV"

    # Per heroku instructions 'Getting Started with Rails 3.x on Heroku at
    # https://devcenter.heroku.com/articles/rails3
    # Set the RACK_ENV to development in your environment
    run('echo "RACK_ENV=development" >>.env')

    git :add => "."
    git :commit => "-am 'use thin via procfile'"

    # heroku precompile requirement
    insert_into_file "config/application.rb", 
    "\n    #Heroku requirement if not precompiling before deployment
        config.assets.initialize_on_precompile = false\n\n",
    before: "  end\nend"

    git :add => "."
    git :commit => "-am 'Append config/application.rb precompile default for heroku.'"
  
    app_name_attempt = ask("What name would you like to deploy your app to heroku as?")
    until (run "heroku create #{app_name_attempt}") do
      app_name_attempt = ask("#{app_name_attempt} didn't work.  What name do you want to try next?")
    end
    run "git push"
    run "git push heroku master"
    run "heroku run rake db:migrate"
  end
end