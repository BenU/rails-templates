# generate static pages
if yes?("Would you like to generate static pages?")
  static_pages = "home "
  static_pages += ask("In addition to home, what other static pages do you want created?
  Please separate your pages by spaces:")
  static_pages_array = static_pages.split()
  generate "controller", "StaticPages #{static_pages}"
  
  # root to home page
  gsub_file('config/routes.rb', /get "static_pages\/home"/, 
    "root to: 'static_pages#home'" )
  remove_file "public/index.html"
  
  # create named routes for our static pages
  static_pages_array.each do |static_page|
    regex_string = "get \"static_pages\\/#{static_page}\""
    if static_page != "home" 
      gsub_file('config/routes.rb', Regexp.new(regex_string), 
        "match '/#{static_page}',  to: 'static_pages\##{static_page}'")
    else
      gsub_file('config/routes.rb', Regexp.new(regex_string), 
        "")
    end   
  end

  # create content for our static pages
  static_pages_array.each do |static_page|
    if static_page == "home"
      h1_text = "#{app_name.titleize}"
      title_string = nil
    else
      h1_text = "#{static_page.titleize}"
      title_string = "#{static_page.titleize}"
    end
    remove_file "app/views/static_pages/#{static_page}.html.erb"
    get "https://raw.github.com/BenU/rails-templates/master/app/views/static_page.html.erb",
      "app/views/static_pages/#{static_page}.html.erb"
    gsub_file "app/views/static_pages/#{static_page}.html.erb",
      /title_placeholder/, title_string
    gsub_file "app/views/static_pages/#{static_page}.html.erb",
      /h1_placeholder/, "#{h1_text}"
    run "subl app/views/static_pages/#{static_page}.html.erb"
  end
  puts "Go edit your static pages in sublime text."

  until yes?("Have you updated your static pages?")
  end

  # solicit base title and add title helpers.
  # add full_title helper method to app/helpers/application_helper.rb
  remove_file "app/helpers/application_helper.rb"
  get "https://raw.github.com/BenU/rails-templates/master/app/helpers/application_helper.rb",
    "app/helpers/application_helper.rb"
  # solicit base title and substitute it into app/helpers/application_helper.rb
  base_title_string = ask("What do you want your base title to be?")
  gsub_file "app/helpers/application_helper.rb", 
    /base_title_placeholder/, base_title_string

  git :add => "."
  git :commit => "-am 'Create static pages'"

  # generate some integration tests for the static pages
  puts "generating some static pages integration tests!"
  static_pages_array = static_pages.split()
  stat_pages_integration_tests = 
    "require 'spec_helper'

  describe 'Static Pages' do

    let(:base_title) { \"#{base_title_string}\" } 

    "
  static_pages_array.each do |static_page|
    if static_page == "home"
      visit_page = 'root_path'
      h1_text = "#{app_name.titleize}"
      title_text = "#{base_title_string}"
      home_title_spec = true
    else
      visit_page = "'\/#{static_page}'"
      h1_text = "#{static_page.titleize}"
      title_text = "#{base_title_string} | #{static_page.titleize}"
      home_title_spec = false
    end
    stat_pages_integration_tests += 
      "
    describe \"#{static_page} page\" do

      it \"should have the h1 \'#{h1_text}\'\" do
        visit #{visit_page}
        page.should have_selector('h1', text: '#{h1_text}')
      end

      it \"should have the title '#{static_page.titleize}'\" do
        visit #{visit_page}
        page.should have_selector('title', 
                  text: \"#{title_text}\")
      end\n" 

      if home_title_spec
        stat_pages_integration_tests +=
        "\n      it \"should not have a custom page title \" do
        visit #{visit_page}
        page.should_not have_selector('title', 
                text: '| Home')\n      end\n\n    end\n"
      else
        stat_pages_integration_tests +=
        "\n    end\n"
      end

  end # static_pages_array.each end
  stat_pages_integration_tests += "
end"
  create_file "spec/requests/static_pages_spec.rb", stat_pages_integration_tests

  git :add => "."
  git :commit => "-am 'Create static_pages integration tests.'"  
end