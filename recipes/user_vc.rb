# Note that this "recipe" is really a sub-recipe of the authentication
# recipe which was getting too long itself.

  # update user controller
  # substitute in app/controllers/users_controller.rb
  remove_file "app/controllers/users_controller.rb"
  get "https://raw.github.com/BenU/rails-templates/master/app/controllers/users_controller.rb",
  "app/controllers/users_controller.rb"
  
  # update app/views/users/new.html.erb
  remove_file "app/views/users/new.html.erb"
  get "https://raw.github.com/BenU/rails-templates/master/app/views/users/new.html.erb",
  "app/views/users/new.html.erb"

  # match '/signup', to: 'users#new'
  insert_into_file "config/routes.rb", 
  "  match '/signup',  to: 'users#new'\n\n", 
  before: "  # The priority is based upon order of creation:"