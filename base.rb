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


# create placeholder README.markdown
run "echo 'TODO add readme content' > README.markdown"

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

