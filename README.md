ElvenHut
========

A blog constructor based on Sinatra for building tech posts site. 

---

#Browser support
* Tested with Safari and Firefox on Mountain Lion. All of them is the newest version.
* Evil and OLD browsers (like IE6) will never be supported.

---

#Setup
1. Duplicate the config template **config/config.yaml** and rename it **config_USERNAME.yaml** (which USERNAME is your account name in unix/linux). 
2. Rewrite **config/config_USERNAME.yaml**, specially the database name(default: elvenhut\_database), username and password.
3. ElvenHub can only support **mysql** and **sqlite3** now, special the adapter in config file. You should create database manually if you use mysql:
<pre><code>mysql>> create database #{database name defined in config/config_USERNAME.yaml} DEFAULT CHARSET utf8;</code></pre>
4. Install all dependence gems. Be sure that all gems are installed successed.
<pre><code>ElvenHut$ bundle install</code></pre>
5. Apply migrations to run Sequel's migrator with bin/sequel -m, and then run the server :
<pre><code>ElvenHut$ rake server</code></pre>

---

#New Feature#
* Feb 2th, 2013: Import archives from wordpress xml.

---
