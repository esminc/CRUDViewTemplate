#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

while (l = $stdin.gets)
  l.gsub!(/CrudViewController/) {|m| "«FILEBASENAMEASIDENTIFIER»"}
  puts l
end
