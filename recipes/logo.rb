# get logo placeholder
if yes?("Do you have a logo image (png formate only) you would like to use?")
  logo_path = ask("What is the path to your logo file?")
else 
  logo_path = "https://raw.github.com/BenU/rails-templates/master/app/assets/images/logo.png"
end
get logo_path, "app/assets/images/logo.png"
git add: "."
git commit: "-am 'Add logo placeholder image or logo image'"