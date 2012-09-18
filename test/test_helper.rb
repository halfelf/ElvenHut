# encoding: utf-8

require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
Encoding.default_external = "UTF-8" if defined? Encoding

testdir = File.dirname(__FILE__)
$LOAD_PATH.unshift testdir unless $LOAD_PATH.include?(testdir)

appdir = File.dirname(File.dirname(__FILE__)) 
$LOAD_PATH.unshift appdir unless $LOAD_PATH.include?(appdir)



