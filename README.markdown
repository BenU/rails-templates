This is my attempt to put together some rails templates to speed up getting my apps off the ground.  

I hope that these templates will serve two purposes: 1) An evolving repository for my admidly weak understanding of rails best practices and 2) A means to speed up getting apps off the ground.  My rails foundation was laid by Michael Hartl's amazing [Rails Tutorial](http://ruby.railstutorial.org/) which has been added to by Ryan Bate's [RailsCasts](http://railscasts.com/), various folks writing in [stackoverflow](http://stackoverflow.com/) and other generous souls scattered around the web.  I hope I cited specific sources in my comments.

Most recently I've started working my way through ["The Rails View"](http://pragprog.com/book/warv/the-rails-view) by John Athayde and Bruce Williams and indeed it was frustration with the inconvenience of recording notes on their book that inspired my detour into [Rails Templates](http://guides.rubyonrails.org/generators.html) in the first place.  As of 02012-Aug-21 I've only made it up to page 24 and have set it aside to get my basic template started.  What you see in app assets and views/layouts was inspired by the book.  They make their code available themselves [here.](http://pragprog.com/titles/warv/source_code)  Hopefully I'll to return to their book soon which will lead to even better and more complete view practices.  If you find the app assets stuff here useful, consider doing what I did and consider buying "The Rails View" book or e-version.  

# Usage

1) create new [www.github.com] repository with name of your new app.  Note: After making repository on github, do not follow additional instructions for github deployment in the command line.  All that is automated in the template.

2) Create postgres database
- in rails directory
```$ mkdir [new app name]
$ cd [new app name]
$ postgres -D /usr/local/var/postgres
3) In new tab:
$ rails new [app name] -m [template file or url]```

Note: I changed my default rails new generator to skip test unit and use postgresql with
`$ echo -d postgresql -T > ~/.railsrc`
So:
I don’t do this:  `$ rails new [app name] -d postgresql --skip-test-unit -m [template file]`
I use the following:
`$ rails new [app name] -m [template file or url]`
eg
`$ rails new [app name] -m https://raw.github.com/BenU/rails-templates/master/main.rb`

**TODO's Sept 11, 02012**
* add full_title utility to specs, then refactor to test full_title method
* finish setting up authentication -- I'm thinking that I'm going to use an 
authentication gem now...
* offer dynamic attributes to user resource created in authentication
* create rvm gemset
* set up for email with sendgrid
* add forgot password to authentication
* Add nifty generator gem or role own scaffold generator

–

Copyright © 2012 Benjamin Unger

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.