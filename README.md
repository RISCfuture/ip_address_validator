# ip_address_validator

[![CI](https://github.com/RISCfuture/ip_address_validator/actions/workflows/ci.yml/badge.svg)](https://github.com/RISCfuture/ip_address_validator/actions/workflows/ci.yml)
[![Gem Version](https://img.shields.io/gem/v/ip_address_validator.svg)](https://rubygems.org/gems/ip_address_validator)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A localizable `EachValidator` for IPv4 and IPv6 address fields, with optional
restrictions on CIDR, loopback, private, and reserved ranges. Works with any
class that uses `ActiveModel::Validations` (Rails models, plain Ruby objects
that `include ActiveModel::Validations`, etc.).

## Installation

```ruby
gem "ip_address_validator", "~> 2.0"
```

Requires Ruby 3.1 or newer and `activemodel >= 6.1`.

## Usage

```ruby
class User
  include ActiveModel::Validations
  attr_accessor :last_login_ip

  validates :last_login_ip, ip_address: true
end
```

### Options

| Option         | Default | Description                                                                                                |
|:---------------|:-------:|:-----------------------------------------------------------------------------------------------------------|
| `:ipv4_only`   | `false` | If `true`, IPv6 addresses are considered invalid.                                                          |
| `:ipv6_only`   | `false` | If `true`, IPv4 addresses are considered invalid.                                                          |
| `:allow_cidr`  | `false` | If `true`, CIDR notation (e.g. `10.0.0.0/24`) is accepted. Otherwise any value containing `/` is rejected. |
| `:no_loopback` | `false` | If `true`, loopback addresses (`127.0.0.0/8`, `::1`) are rejected.                                         |
| `:no_private`  | `false` | If `true`, RFC 1918 ranges and IPv6 unique local (`fc00::/7`) are rejected.                                |
| `:no_reserved` | `false` | If `true`, link-local, multicast, broadcast, documentation, and other reserved blocks are rejected.        |
| `:message`     | —       | Custom error message.                                                                                      |
| `:allow_nil`   | `false` | If `true`, `nil` values are allowed.                                                                       |
| `:allow_blank` | `false` | If `true`, blank values are allowed.                                                                       |

### Examples

```ruby
# Only allow public, non-CIDR IPv4 addresses.
validates :webhook_source_ip, ip_address: {
  ipv4_only: true,
  no_loopback: true,
  no_private: true,
  no_reserved: true
}

# Allow a CIDR block (e.g. for an IP allowlist field).
validates :allowlist_entry, ip_address: { allow_cidr: true }

# Custom message.
validates :remote_ip, ip_address: { message: "must be a valid IP" }
```

### Localization

The error key is `invalid_ip`. Define it under the usual ActiveModel
errors hierarchy:

```yaml
en:
  activemodel:
    errors:
      messages:
        invalid_ip: "is not a valid IP address"
```

## Development

```sh
bin/setup
bundle exec rspec
```

## License

Released under the MIT License. See `LICENSE`.
