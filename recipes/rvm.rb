# inspired by greendog99 at 
# https://github.com/greendog99/greendog-rails-template/blob/master/partials/_rvm.rb

# Set up rvm private gemset

puts "Setting up RVM gemset and installing bundled gems (may take a while) ... "

# Need to strip colors in case rvm_pretty_print_flag is enabled in user's .rvmrc
rvm_list = %x( rvm list )

puts "The list of available rubies is:"
puts rvm_list

rubies = []
rvm_list_array = rvm_list.split()
rvm_list_array.each do |ruby|
  rubies << ruby if ruby[0..3] == "ruby"
end
current_ruby = rubies[-1]

desired_ruby = ask("Which RVM Ruby would you like to use? [#{current_ruby}]")
desired_ruby = current_ruby if desired_ruby.blank?

gemset_name = ask("What name should the custom gemset have? [#{@app_name}]")
gemset_name = @app_name if gemset_name.blank?

# Create the gemset
run "rvm #{desired_ruby} gemset create #{gemset_name}"

# Let us run shell commands inside our new gemset. Use this in other template partials.
@rvm = "rvm use #{desired_ruby}@#{gemset_name}"

# Create .rvmrc
file '.rvmrc', @rvm
puts "                  #{@rvm}"

# Make the .rvmrc trusted
run "rvm rvmrc trust #{@app_path}"

# Since the gemset is likely empty, manually install bundler so it can install the rest
# I've commented out the following line since I don't think it's needed
# in my setup.  -- BDU
# run "#{@rvm} gem install bundler"

# Install all other gems needed from Gemfile
run "#{@rvm} exec bundle install"

puts "\n"