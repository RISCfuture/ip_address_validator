# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-05-14

### Breaking
- Bumped minimum Ruby to **3.1**.
- Bumped `activemodel` runtime dependency to **>= 6.1**. `activerecord` is no
  longer a (transitive) dependency; the validator only needs ActiveModel.
- `localized_each_validator` runtime dependency bumped to **>= 2.0**.
- CIDR strings (e.g. `"10.0.0.0/24"`) are **no longer accepted by default**.
  In 1.x they silently passed because `IPAddr.new` accepts them, so subnets
  validated as "IP addresses". Pass `allow_cidr: true` to restore the old
  behavior.
- Non-`String` values are now explicitly rejected.

### Added
- `:allow_cidr` option (default `false`) — opt back in to CIDR notation.
- `:no_loopback` option — rejects `127.0.0.0/8` and `::1`.
- `:no_private` option — rejects RFC 1918 ranges and IPv6 unique local
  (`fc00::/7`).
- `:no_reserved` option — rejects link-local, multicast, broadcast,
  documentation, benchmarking, TEST-NET and other reserved blocks.
- `:allow_blank` is now documented (it was already inherited from
  `LocalizedEachValidator`).
- `IpAddressValidator::VERSION` constant in `lib/ip_address_validator/version.rb`.
- Real test suite (`spec/ip_address_validator_spec.rb`) — previously zero
  tests shipped with the gem.

### Changed
- Replaced jeweler-generated gemspec with a hand-written one using
  `git ls-files` and modern `spec.metadata` (including
  `rubygems_mfa_required`).
- Replaced jeweler-flavored Rakefile with a small RSpec + bundler/gem_tasks
  Rakefile.
- Modernized README; removed Rails-3-era framing.
- Added GitHub Actions matrix (Ruby 3.1–3.4 × activemodel 7.0–8.0).

### Removed
- `jeweler`, `yard`, and `RedCloth`/`redcarpet` dev dependencies.
- `.travis.yml`.
- Stale `README.textile` references.
- The duplicate `add_dependency` lines in the old gemspec.
