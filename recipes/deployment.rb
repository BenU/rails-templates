# push app to github.com
if yes?("Would you like to store source in GitHub repository?")
  github_username = ask("What is your username on github?")
  run "git remote add origin git@github.com:#{github_username}/#{app_name}.git"
  run "git push -u origin master"

  # this code attempts to allow for forgetting to create github repository and
  # other github push failures.  It is akward but hopefully I can get it to
  # work...  Will refactor later.
  github_failure_response = true

  until (run "git push -u origin master") do
    github_failure_response = yes?("Couldn't push to github.  You may need to create a repository or 
    there was some other GitHub based error.  Try again? (y/n)")
    if github_failure_response
      puts "Ok.  Go make the #{app_name} repository at github."
      yes?("Have you made the repository?")
    else
      break if yes?("Want to stop trying?")
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

    if @authentication
      # change this to gsub since more than one 'end' ****** 
      gsub_file "config/environments/production.rb", /www.myappdomain.com/,
        "http://#{app_name_attempt}.herokuapp.com/"
    end
    run "git push"
    run "git push heroku master"
    run "heroku run rake db:migrate"
  end
end