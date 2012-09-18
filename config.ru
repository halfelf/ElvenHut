
appdir = File.dirname(__FILE__)
$LOAD_PATH.unshift appdir unless $LOAD_PATH.include?(appdir)
require 'route'

run ElvenHut
