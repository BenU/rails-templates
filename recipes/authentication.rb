# authentication
if yes?("Would you like to add user authentication?")
  @authentication = true
  gem("devise", "~> 2.1.2")
  run 'bundle install'
  run 'rails generate devise:install'

  run 'subl config/initializers/devise.rb'

  until yes?("Have you reviewed the devise initializer? eg update the `mailer_sender?`")
  end

  gsub_file "config/environments/development.rb", /\nend/,
    "\n  config.action_mailer.default_url_options = { :host => '0.0.0.0:5000' }\nend"

  gsub_file "config/environments/production.rb", /\nend/,
    "\n  config.action_mailer.default_url_options = { :host => 'www.myappdomain.com' }\nend"

  unless @static_pages
    insert_into_file "config/routes.rb",
      "\n  root :to => \"public#index.html\"\n",
      after: "::Application.routes.draw do"
  end

  puts "Next add the User attributes.  Devise will add a unique email attribute"
  puts "plus password attributes so leave those off."
  user_attributes = ask("List attributes in format [field[:type][:index/unique]]")
  attributes_confirmed = false
  until attributes_confirmed
    if yes?("Are you happy with the attribute string \"#{user_attributes}\"?")
      attributes_confirmed = true
    else
      user_attributes = ask("List attributes in format [field[:type][:index/unique]]")
    end
  end
  puts "#{user_attributes}"

  run "rails g model User #{user_attributes}"

  # generate user model
  rake "db:migrate"
  rake "db:test:prepare"

  # attributes generated by devise are
  #  :email, :password, :password_confirmation, :remember_me
  # specs for the devise attributes are already written in the template.
  # see next lines for `update model specs`
  
  # udpate model specs
  remove_file "spec/models/user_spec.rb"
  get "https://raw.github.com/BenU/rails-templates/master/spec/models/user_spec.rb",
  "spec/models/user_spec.rb" 

  # **** remove baseline factory and replace with empty user factory
  remove_file "spec/factories/users.rb"
  get "https://raw.github.com/BenU/rails-templates/master/spec/factories/users.rb",
  "spec/factories/users.rb"  

  # udpate `spec/models/user_spec.rb` with dynamically generated
  # specs for new user attributes.  Some are `pending` placeholders
  attributes_accesible = []
  attributes_protected = []

  user_attributes.split.each do |attribute_string|
    attribute_array = attribute_string.split(":")
    attribute, data_type, index_unique = attribute_array[0], attribute_array[1], attribute_array[2]    

    if yes?("Do you want #{attribute} to be attributes_accesible?")
      attributes_accesible << attribute
      attribute_accesible = true
    else
      attributes_protected << attribute
      attribute_accesible = false
    end

    unless index_unique == "unique"
      attribute_default = ask("In user_spec.rb, what do you want the #{data_type} default value for #{attribute} to be?")
    else
      # attribute is unique and should include a #{n}
      puts "In user_spec.rb, what do you want the #{data_type} default value for #{attribute} to be?"
      until /\#\{n\}/ =~ attribute_default
        attribute_default = ask('Include #{n} in your unique default data:')
      end
    end
    
    # convert `attribute_default` string to appropriate data-type
    attribute_default = case data_type
                        when "boolean"
                          attribute_default == "true" ? true : false
                        when "decimal"
                          require 'bigdecimal'
                          BigDecimal.new(attribute_default)
                        when "float"
                          attribute_default.to_f
                        when "integer"
                          attribute_default.to_i
                        when "date"
                          # just keep as string... and add quotation marks
                          "\"#{attribute_default}\""                          
                        else 
                          # just keep as string... and add quotation marks
                          "\"#{attribute_default}\""
                        end

    # Add attribute to user factory
    if (index_unique == nil) || (index_unique == "index")
      insert_into_file "spec/factories/users.rb",
        "    #{attribute} #{attribute_default}\n",
        after: "factory :user do\n"
    else # index_unique == "unique"
      insert_into_file "spec/factories/users.rb",
        "    sequence(:#{attribute}) { |n| #{attribute_default} }\n",
        after: "factory :user do\n" 
    end

    # add spec and pending placeholder for attribute to spec/models/user_spec.rb 
    insert_into_file "spec/models/user_spec.rb",
      "  it { should respond_to(:#{attribute}) }\n",
      before: "#_additional_attributes_specs"

    insert_into_file "spec/models/user_spec.rb",
      "  pending \"add some custom specs for #{attribute}.\"\n",
      after: "# add pending specs for additional attributes"


    # add specs to make sure that protected attributes can not changed
    # via mass assignment
    unless attribute_accesible
      insert_into_file "spec/models/user_spec.rb",
        "it \"should not allow access to #{attribute}\" do
        expect do
          User.new(#{attribute}: #{attribute_default})
        end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
      ",
      after: "  describe \"accessible attributes\" do\n"

    end

  end





  # add devise attributes -- email, password and password_confirmation --
  # to user factory
  insert_into_file "spec/factories/users.rb",
    '    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
',
    after: "factory :user do\n" 

  # remove placeholders from `spec/models/user_spec.rb`
  gsub_file "spec/models/user_spec.rb", /#additional_attributes/, ""
  gsub_file "spec/models/user_spec.rb", /#_additional_attributes_specs/, ""
  gsub_file "spec/models/user_spec.rb", /# add pending specs for additional attributes/, ""

  until yes?("Get spork running in additional terminal tab.  Ready to proceed?")
  end
  run "rspec spec"

  run 'rails generate devise User'

  # add email validation and password_confirmation presence: true to models/user.rb
  insert_into_file "app/models/user.rb",
    "\n\n  VALID_EMAIL_REGEX = /\\A[\\w+\\-.]+@[a-z\\d\\-.]+\\.[a-z]+\\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true\n\n",
    before: "\nend"

  # **** Add email, password and password_confirmation to user factory  

  run 'subl app/models/user.rb'

  until yes?("Have you reviewed the user model devise options?")
  end

  devise_migration_file = Dir['db/migrate/*_add_devise_to_users.rb'].first
  run "subl #{devise_migration_file}"

  until yes?("Have you reviewed and updated the `_add_devise_to_users` migration?")
  end

  rake "db:migrate"
  rake "db:test:prepare"

  until yes?("Restart spork in additional terminal tab.  Ready to proceed?")
  end
  run "rspec spec"

  # set up integration tests to make sure the all attributes_accessible
  # attributes are on the sign up form.

  # set up integration tests to make sure that all attributes_protected
  # attributes are not on the sign up form

=begin

  # generate integration tests for user pages based on model attributes
  # ***** Add click_link "Sign up now!" integration test to end of layout links specs 
  # on static_pages integration tests

  # generate user controller, routes and views

  # get user pages integration tests
  get "https://raw.github.com/BenU/rails-templates/master/spec/requests/user_pages_spec.rb", 
  "spec/requests/user_pages_spec.rb"


  # annotate the user model
  run "annotate --position before"
  
  # git commit
  git add: "."
  git commit: "-am 'Add user and basic authentication'"
=end
end
