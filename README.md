El Dorado
=========

El Dorado (for NATF2) is a full-stack community web application written in Ruby/Rails.
It features a forum, event calendar, group chat, file sharing, random headers,
avatars, themes, and privacy settings.

- Code: <http://github.com/trevorturk/eldorado/>
- Demo and support site: <http://eldorado.heroku.com/>
- Examples: <http://wiki.github.com/trevorturk/eldorado/> # add your site!


Screenshot
----------

![Screenshot](http://s3.amazonaws.com/trevorturk/eldorado.png)


Install
----------

    git clone git://github.com/dekom/eldorado-natf2.git
    cd eldorado-natf2
    cp config/database.example.yml config/database.yml
    cp config/settings/development.example.yml config/settings/development.local.yml
    gem install bundler
    bundle install --without production
    rake db:create
    rake db:schema:load
    rails server

Visit <http://localhost:3000/> to see the app running locally.


Deploy
------

Deploy the app to Heroku:

    gem install heroku
    heroku create
    cp config/settings/production.example.yml config/settings/production.local.yml
    # set the variables for your production environment in config/settings/production.local.yml
    rake s3:create
    rake heroku:config
    git push heroku master
    heroku rake db:schema:load
    heroku open


MIT License
-----------

Copyright (c) 2006-* Trevor Turk
Copyright (c) 2011-* Luke Curley
Copyright (c) 2011-* Xing Zhou

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
