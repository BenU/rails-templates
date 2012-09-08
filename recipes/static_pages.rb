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
    run "subl app/views/static_pages/#{static_page}.html.erb"
  end
  puts "Go edit your static pages in sublime text."

  until yes?("Have you updated your static pages?")
  end

  # create base title and titles for static pages.
  base_title = ask("What do you want your base title to be?")
  ### add code here to create base title and static page titles

  git :add => "."
  git :commit => "-am 'Create static pages'"

  # generate some integration tests for the static pages
  # which fail... and should be refactored anywhoo.
  puts "generating some static pages integration tests!"
  static_pages_array = static_pages.split()
  stat_pages_integration_tests = 
    "require 'spec_helper'

  describe 'Static Pages' do
    "
  static_pages_array.each do |static_page|
    if static_page != "home"
    stat_pages_integration_tests += 
      "
    describe \"#{static_page} page\" do

      it \"should have the h1 \'#{static_page.titleize}\'\" do
        visit \'/#{static_page}\'
        page.should have_selector('h1', text: '#{static_page.titleize}')
      end

      it \"should have the title \'#{base_title} | #{static_page.titleize}\'\" do
        visit \'/#{static_page}\'
        page.should have_selector('title', 
                  text: \'#{base_title} | #{static_page.titleize}\')
      end

    end
  "
    else # static_page == "home"
      stat_pages_integration_tests += 
      "
    describe \"Home page\" do
      it \"should have the content '#{app_name.titleize}'\" do
        visit root_path
        page.should have_content('#{app_name.titleize}')
      end

      it \"should have the title \'#{base_title} | #{static_page.titleize}\'\" do
        visit root_path
        page.should have_selector('title', 
                  text: \'#{base_title} | #{static_page.titleize}\')
      end

    end
  "
    end
  end # static_pages_array.each end
  stat_pages_integration_tests += "
end"
  create_file "spec/requests/static_pages_spec.rb", stat_pages_integration_tests

  git :add => "."
  git :commit => "-am 'Create static_pages integration tests.'"  
end