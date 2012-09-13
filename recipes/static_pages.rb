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

  # add links to static pages in page footer
  static_pages_array.each do |static_page|
    if static_page == "home"
      insert_into_file "app/views/layouts/_header.html.erb",
      "\t<%= link_to \"Home\", root_path %>\n\t",
      after: "<nav id=\"navigation\">"
    else
      insert_into_file "app/views/layouts/_footer.html.erb",
      "\t<%= link_to \"#{static_page.titleize}\", #{static_page}_path %>\n\t",
      before: "</nav>"
    end
  end


  # create content for our static pages
  static_pages_array.each do |static_page|
    if static_page == "home"
      h1_text = "#{app_name.titleize}"
      title_string = ""
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
  # get full_title method for use with specs
  get "https://raw.github.com/BenU/rails-templates/master/spec/support/utilities.rb", 
  "spec/support/utilities.rb"
  gsub_file "spec/support/utilities.rb", /base_title_placeholder/, 
    "#{base_title_string}"

  static_pages_array = static_pages.split()
  stat_pages_integration_tests = "require 'spec_helper'
  
  describe 'Static Pages' do

    let(:base_title) { \"#{base_title_string}\" } 

    subject { page }

    shared_examples_for \"all static pages\" do
      it { should have_selector('h1',    text: heading) }
      it { should have_selector('title', text: full_title(page_title)) }
    end\n"

  stat_pages_layout_links_tests = "\t\tit \"should have the right links on the layout\" do
    \tvisit root_path\n"

  static_pages_array.each do |static_page|
    if static_page == "home"
      visit_page = 'root_path'
      h1_text = "#{app_name.titleize}"
      title_text = "''"
      home_title_spec = true
    else
      visit_page = "#{static_page}_path"
      h1_text = "#{static_page.titleize}"
      title_text = "'#{static_page.titleize}'"
      home_title_spec = false
    end
    
    stat_pages_integration_tests += "\n\t\tdescribe \"#{static_page} page\" do
      before { visit #{visit_page} }
      let(:heading)     { '#{h1_text}' }
      let(:page_title)  { #{title_text} }

      it_should_behave_like \"all static pages\"\n"
        
      if home_title_spec
        stat_pages_integration_tests += "\t\t\tit { should_not have_selector 'title', text: '| Home' }\n\t\tend\n"
        stat_pages_layout_links_tests += "\t\t\tclick_link \"Home\"
    page.should have_selector 'title', text: full_title(#{title_text})\n"
      else
        stat_pages_integration_tests += "\n\t\tend\n"
        stat_pages_layout_links_tests += "\tclick_link \"#{h1_text}\"
  page.should have_selector 'title', text: full_title(#{title_text})\n"
      end
  end # static_pages_array.each end

  stat_pages_integration_tests += "\n#{stat_pages_layout_links_tests}\n\tend\nend"
  create_file "spec/requests/static_pages_spec.rb", stat_pages_integration_tests

  git :add => "."
  git :commit => "-am 'Create static_pages integration tests.'"  
end