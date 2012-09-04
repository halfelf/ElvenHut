#ElvenHut

A blog constructor builed based on Sinatra for self-using. 

##Setup
* Rewrite **config/config.yaml**, specially the database name(default: elvenhut\_database), username and password.
* ElvenHub can only support **mysql** now, create database in mysql:
<pre><code>mysql>> create database #{database name defined in config/config.yaml};</code></pre>
* Install all dependence gems
<pre><code>ElvenHut$ bundle install</code></pre>
Be sure that all gems are installed successed.
* Run Setup ruby script:
<pre><code>ElvenHut$ ruby setup.rb</code></pre>
* Then run the server:
<pre><code>Elvenhut$ rake</code></pre>
