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