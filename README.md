ElvenHut
========

A blog constructor based on Sinatra for building tech posts site. 

##Browser support
* Tested with Safari and Firefox on Mountain Lion. All of them is the newest version.
* Evil and OLD browsers (like IE6) will never be supported.

##Setup
* Duplicate the config template **config/config.yaml** and rename it **config_USERNAME.yaml** (which USERNAME is your account name in unix/linux). 
* Rewrite **config/config_USERNAME.yaml**, specially the database name(default: elvenhut\_database), username and password.
* ElvenHub can only support **mysql** now, create database in mysql:
<pre><code>mysql>> create database #{database name defined in config/config_USERNAME.yaml};</code></pre>
* Install all dependence gems. Be sure that all gems are installed successed.
<pre><code>ElvenHut$ bundle install</code></pre>
* Apply migrations to run Sequel's migrator with bin/sequel -m:
<pre><code>ElvenHut$ ruby setup.rb</code></pre>
* Then run the server:
<pre><code>ElvenHut$ rake server</code></pre>
* To run tests:
<pre><code>ElvenHut$ rake</code></pre>
