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
  gem.files = %w( lib/**/* LICENSE README.md ip_address_validator.gemspec )
end
Jeweler::RubygemsDotOrgTasks.new

require 'yard'

# bring sexy back (sexy == tables)
module YARD::Templates::Helpers::HtmlHelper
  def html_markup_markdown(text)
    markup_class(:markdown).new(text, :gh_blockcode, :fenced_code, :autolink, :tables, :no_intraemphasis).to_html
  end
end

YARD::Rake::YardocTask.new('doc') do |doc|
  doc.options << '-m' << 'markdown'
  doc.options << '-M' << 'redcarpet'
  doc.options << '--protected' << '--no-private'
  doc.options << '-r' << 'README.md'
  doc.options << '-o' << 'doc'
  doc.options << '--title' << 'ip_address_validator Documentation'

  doc.files = %w(lib/*.rb README.md)
end
