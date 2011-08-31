require 'localized_each_validator'

# Validates IPv4 and IPv6 addresses. Uses the @invalid_ip@ error message key.
#
# @example
#   validates :last_login_ip, ip_address: true
#
# h2. Options
#
# | @:ipv4_only@ | If @true@, IPv6 addresses are considered invalid. |
# | @:ipv6_only@ | If @true@, IPv4 addresses are considered invalid. |
# | @:message@ | A custom message to use if the IP is invalid. |
# | @:allow_nil@ | If true, @nil@ values are allowed. |

class IpAddressValidator < LocalizedEachValidator
  error_key :invalid_ip

  # @private
  def valid?(_, _, value)
    ip = nil
    begin
      ip = IPAddr.new(value)
    rescue ArgumentError
      return false
    end
    
    return false if ip.ipv4? and options[:ipv6_only]
    return false if ip.ipv6? and options[:ipv4_only]
    
    return true
  end
end