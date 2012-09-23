This is my attempt to put together some rails templates to speed up getting my apps off the ground.  

I hope that these templates will serve two purposes: 1) An evolving repository for my admidly weak understanding of rails best practices and 2) A means to speed up getting apps off the ground.  My rails foundation was laid by Michael Hartl's amazing [Rails Tutorial](http://ruby.railstutorial.org/) which has been added to by Ryan Bate's [RailsCasts](http://railscasts.com/), various folks writing in [stackoverflow](http://stackoverflow.com/) and other generous souls scattered around the web.  I hope I cited specific sources in my comments.

Most recently I've started working my way through ["The Rails View"](http://pragprog.com/book/warv/the-rails-view) by John Athayde and Bruce Williams and indeed it was frustration with the inconvenience of recording notes on their book that inspired my detour into [Rails Templates](http://guides.rubyonrails.org/generators.html) in the first place.  As of 02012-Aug-21 I've only made it up to page 24 and have set it aside to get my basic template started.  What you see in app assets and views/layouts was inspired by the book.  They make their code available themselves [here.](http://pragprog.com/titles/warv/source_code)  Hopefully I'll to return to their book soon which will lead to even better and more complete view practices.  If you find the app assets stuff here useful, consider doing what I did and consider buying "The Rails View" book or e-version.  

# Usage

1) create new [GitHub](www.github.com) repository with name of your new app.  Note: After making repository on github, do not follow additional instructions for github deployment in the command line.  All that is automated in the template.

2) Create postgres database
in rails directory

    $ mkdir [new app name]
    $ cd [new app name]
    $ postgres -D /usr/local/var/postgres

3) In new tab:

    $ rails new [app name] -m [template file or url]

Note: I changed my default rails new generator to skip test unit and use postgresql with
`$ echo -d postgresql -T > ~/.railsrc`
So:
I don’t do this:  `$ rails new [app name] -d postgresql --skip-test-unit -m [template file]`
I use the following:

    $ rails new [app name] -m [template file or url]

eg

    $ rails new [app name] -m https://raw.github.com/BenU/rails-templates/master/main.rb

# A Note on Testing

I'm convinced that testing is important to developing robust apps that can be refactored and upgraded with confidence.  That said, testing appropriately can be hard.  I've lost weeks trying to figure out how to test appropriately when I've already figured out how to get the "test" to pass.  For the purposes of this template, I will set up tests for the produced app.  This allows the template to produce apps which are well on their way to appropriate testing but leaves the template itself more brittle.  I am aware of that deficit but currently unsure of the code needed to test the template itself.  I'll continue to look for solutions -- examples on testing gems in [Rails Antipatterns](http://railsantipatterns.com/) looks promising -- as I go along but won't let not understanding that concept slow me down yet here.  Please reach out if you have insight into appropriately testing one's template, though.  I'd love to hear from you!

**TODO's Sept 23, 02012**
* Finish setting up authentication
  - solicit accessible attributes
  - set up integration tests to make sure appropriate attributes are on signup/edit forms
  - update user model such that appropriate attributes are attribute accessible
  - generate integration tests to sign up user with valid attribute values but not with invalid attribute values 
  - update user model with attribute validations
  - generate integration test for user destroying their own account
  - generate tests for appropriate utility links when signed in/out
  - add utility links to layouts/application.html.erb
  - integration test for email sent when password forgotten
  - set up for email with sendgrid and get tests to pass

**Additional Items to do specific to generated app
* Set up [can can](https://github.com/ryanb/cancan) for roles and authorization
* Performant checklist - Remove unneeded aspects of rails, New Relic, chaching, sprites, t/c Blitz, Cloud Assault
* uptime checklist - Ranger
* error logging - Airbrake, Sentry, StatsMix, StillAlive
* SSL encryption
* Security checklist, brakeman, etc.  T/c Strong Parameters,  See [The Ruby Toolbox](https://www.ruby-toolbox.com/) [Security Tools page](https://www.ruby-toolbox.com/categories/security_tools).
* Keep site up to date with SourceNinja
* See ThoughtBot "[The Playbook](http://playbook.thoughtbot.com/)" for more ideas on integrating best practices.

–

Copyright © 2012 Benjamin Unger

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.