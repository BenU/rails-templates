# generate static pages
if yes?("Would you like to generate static pages?")
  static_pages = "home "
  static_pages += ask("In addition to home, what other static pages do you want created?
  Please separate your pages by spaces:")
  generate "controller", "StaticPages #{static_pages}"
  route("root :to => 'static_pages#home'")
  remove_file "public/index.html"

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
    stat_pages_integration_tests += 
    "
  describe \"#{static_page} page\" do
    it \"should have the content \'#{static_page.capitalize}\'\" do
      visit \'/static_pages/#{static_page}\'
      page.should have_content(\'#{static_page.capitalize}\')
    end
  end
"
  end
    stat_pages_integration_tests += "
end"
  create_file "spec/requests/static_pages_spec.rb", stat_pages_integration_tests

  git :add => "."
  git :commit => "-am 'Create static_pages integration test placeholders.'"  
end