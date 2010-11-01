require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "ip_address_validator"
  gem.summary = %Q{Simple IP address validation in Rails 3}
  gem.description = %Q{A simple, localizable EachValidator for IPv4 and IPv6 address fields in ActiveRecord 3.0.}
  gem.email = "git@timothymorgan.info"
  gem.homepage = "http://github.com/riscfuture/ip_address_validator"
  gem.authors = [ "Tim Morgan" ]
end
Jeweler::RubygemsDotOrgTasks.new

require 'yard'
YARD::Rake::YardocTask.new('doc') do |doc|
  doc.options << "-m" << "textile"
  doc.options << "--protected"
  doc.options << "-r" << "README.textile"
  doc.options << "-o" << "doc"
  doc.options << "--title" << "ip_address_validator Documentation".inspect
  
  doc.files = [ 'lib/*.rb', 'README.textile' ]
end
