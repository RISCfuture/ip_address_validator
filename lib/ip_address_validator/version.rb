# frozen_string_literal: true

# Bare version constant. Lives in its own module so this file can be required
# from the gemspec without pulling in the rest of the gem (or its runtime
# dependencies). `lib/ip_address_validator.rb` re-exposes this as
# `IpAddressValidator::VERSION` once the validator class is defined.
module IpAddressValidatorGem
  VERSION = "2.0.0"
end
