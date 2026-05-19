# frozen_string_literal: true

require_relative "lib/ip_address_validator/version"

Gem::Specification.new do |spec|
  spec.name        = "ip_address_validator"
  spec.version     = IpAddressValidatorGem::VERSION
  spec.authors     = ["Tim Morgan"]
  spec.email       = ["git@timothymorgan.info"]

  spec.summary     = "Simple IP address validator for ActiveModel"
  spec.description = "A localizable EachValidator for IPv4 and IPv6 address fields, with optional " \
                     "restrictions on CIDR, loopback, private, and reserved ranges."
  spec.homepage    = "https://github.com/RISCfuture/ip_address_validator"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.2"

  spec.metadata = {
    "source_code_uri"       => "https://github.com/RISCfuture/ip_address_validator",
    "changelog_uri"         => "https://github.com/RISCfuture/ip_address_validator/blob/master/CHANGELOG.md",
    "bug_tracker_uri"       => "https://github.com/RISCfuture/ip_address_validator/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(__dir__) do
    tracked =
      begin
        `git ls-files -z`.split("\x0")
      rescue StandardError
        []
      end
    candidates = tracked.empty? ? Dir["**/*"] : tracked
    candidates.select { |f| File.file?(f) }.reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github .idea Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 6.1"
  spec.add_dependency "localized_each_validator", ">= 2.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
