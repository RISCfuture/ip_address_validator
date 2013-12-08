ip_address_validator
====================

**Simple IP validator for Rails 3+**

|             |                                 |
|:------------|:--------------------------------|
| **Author**  | Tim Morgan                      |
| **Version** | 1.0.1 (Mar 19, 2012)            |
| **License** | Released under the MIT license. |

About
-----

This gem adds a very simple IP address format validator to be used with
ActiveRecord models in Rails 3.0. It supports localized error messages.

Installation
------------

Add the gem to your project's `Gemfile`:

```` ruby
gem 'ip_address_validator'
````

Usage
-----

This gem is an `EachValidator`, and thus is used with the `validates` method:

```` ruby
class User < ActiveRecord::Base
  validates :last_login_ip,
			ip_address: true
end
````

The localization key is `invalid_ip`, and can be specified in the localized
YAML file like so:

```` yaml
en:
  activerecord:
	errors:
	  messages:
	    invalid_ip: IP address is invalid.
````
