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