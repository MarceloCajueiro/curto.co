# config.ru
$:.unshift File.expand_path("./../lib", __FILE__)

require "rubygems"
require "app"

run UrlShortener::App
