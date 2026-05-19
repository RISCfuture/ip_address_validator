# frozen_string_literal: true

require "ipaddr"
require "localized_each_validator"

require_relative "ip_address_validator/version"

# `IpAddressValidator` is defined here (not in `version.rb`) because its
# superclass `LocalizedEachValidator` isn't loaded until this file runs.

# Validates IPv4 and IPv6 addresses. Uses the `invalid_ip` error message key.
#
# @example
#   validates :last_login_ip, ip_address: true
#
# Options
# -------
#
# |                 |                                                              |
# |:----------------|:-------------------------------------------------------------|
# | `:ipv4_only`    | If `true`, IPv6 addresses are considered invalid.            |
# | `:ipv6_only`    | If `true`, IPv4 addresses are considered invalid.            |
# | `:allow_cidr`   | If `true`, CIDR notation (e.g. `10.0.0.0/24`) is allowed.    |
# |                 | Defaults to `false`, so values containing `/` are rejected.  |
# | `:no_loopback`  | If `true`, loopback addresses (e.g. `127.0.0.1`, `::1`)      |
# |                 | are considered invalid.                                      |
# | `:no_private`   | If `true`, RFC 1918 / unique local addresses (e.g.           |
# |                 | `10.0.0.0/8`, `fc00::/7`) are considered invalid.            |
# | `:no_reserved`  | If `true`, reserved addresses (link-local, multicast,        |
# |                 | unspecified, etc.) are considered invalid.                   |
# | `:message`      | A custom message to use if the IP is invalid.                |
# | `:allow_nil`    | If `true`, `nil` values are allowed.                         |
# | `:allow_blank`  | If `true`, blank values are allowed.                         |

class IpAddressValidator < LocalizedEachValidator
  VERSION = IpAddressValidatorGem::VERSION

  error_key :invalid_ip

  # @private
  def valid?(_record, _attribute, value)
    return false unless value.kind_of?(String)
    return false if !options[:allow_cidr] && value.include?("/")

    begin
      ip = IPAddr.new(value)
    rescue ArgumentError
      return false
    end

    return false if ip.ipv4? && options[:ipv6_only]
    return false if ip.ipv6? && options[:ipv4_only]

    return false if options[:no_loopback] && ip.loopback?
    return false if options[:no_private] && private_ip?(ip)
    return false if options[:no_reserved] && reserved_ip?(ip)

    true
  end

  private

  def private_ip?(ip)
    return true if ip.respond_to?(:private?) && ip.private?

    # Fallback for older Ruby versions: cover RFC 1918 + unique local IPv6.
    if ip.ipv4?
      %w[10.0.0.0/8 172.16.0.0/12 192.168.0.0/16].any? { |r| IPAddr.new(r).include?(ip) }
    elsif ip.ipv6?
      IPAddr.new("fc00::/7").include?(ip)
    else
      false
    end
  end

  def reserved_ip?(ip)
    return true if ip.link_local?
    return true if ip.respond_to?(:multicast?) ? ip.multicast? : false
    return true if ["0.0.0.0", "::"].include?(ip.to_s)

    if ip.ipv4?
      reserved_v4 = %w[
          0.0.0.0/8
          100.64.0.0/10
          169.254.0.0/16
          192.0.0.0/24
          192.0.2.0/24
          198.18.0.0/15
          198.51.100.0/24
          203.0.113.0/24
          224.0.0.0/4
          240.0.0.0/4
          255.255.255.255/32
      ]
      reserved_v4.any? { |r| IPAddr.new(r).include?(ip) }
    elsif ip.ipv6?
      reserved_v6 = %w[
          ::/128
          ::1/128
          ff00::/8
          2001:db8::/32
          100::/64
      ]
      reserved_v6.any? { |r| IPAddr.new(r).include?(ip) }
    else
      false
    end
  end
end
