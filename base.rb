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