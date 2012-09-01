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
