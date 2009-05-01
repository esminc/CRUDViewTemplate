#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

while (l = $stdin.gets)
  l.gsub!(/CrudViewController/) {|m| "«FILEBASENAMEASIDENTIFIER»"}
  l.gsub!(/^#import \"CrudViewController.h\"$/) {|m| "«OPTIONALHEADERIMPORTLINE»"}
  puts l
end
