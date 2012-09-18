ElvenHut
========

A blog constructor builed based on Sinatra for self-using. 

##Setup
* Duplicate the config template **config/config.yaml** and rename it **config_USERNAME.yaml** (which USERNAME is your account name in unix/linux). 
* Rewrite **config/config_USERNAME.yaml**, specially the database name(default: elvenhut\_database), username and password.
* ElvenHub can only support **mysql** now, create database in mysql:
<pre><code>mysql>> create database #{database name defined in config/config_USERNAME.yaml};</code></pre>
* Install all dependence gems
<pre><code>ElvenHut$ bundle install</code></pre>
Be sure that all gems are installed successed.
* Then run the server:
<pre><code>Elvenhut$ rackup config.ru</code></pre>
