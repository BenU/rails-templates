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