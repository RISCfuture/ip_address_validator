# frozen_string_literal: true

require "spec_helper"

module SpecSupport
  # A small ActiveModel-backed object we can validate against.
  class TestModel
    include ActiveModel::Validations
    attr_accessor :ip
  end
end

RSpec.describe IpAddressValidator do
  # Build a fresh model class per example so calls to `validates` don't leak.
  def model_class(**opts)
    Class.new(SpecSupport::TestModel) do
      validates :ip, ip_address: opts.empty? ? true : opts
    end
  end

  def expect_valid(value, **opts)
    m = model_class(**opts).new
    m.ip = value
    expect(m).to be_valid, -> { "expected #{value.inspect} valid (opts=#{opts.inspect}); errors=#{m.errors.full_messages}" }
  end

  def expect_invalid(value, **opts)
    m = model_class(**opts).new
    m.ip = value
    expect(m).not_to be_valid, -> { "expected #{value.inspect} invalid (opts=#{opts.inspect})" }
    m
  end

  describe "IPv4" do
    it "accepts well-formed IPv4 addresses" do
      %w[0.0.0.0 1.2.3.4 192.168.1.1 255.255.255.255 8.8.8.8].each { |v| expect_valid(v) }
    end

    it "rejects malformed IPv4 addresses" do
      [
        "999.999.999.999",
        "1.2.3",
        "1.2.3.4.5",
        "abc.def.ghi.jkl",
        "1.2.3.4 ",
        "",
        "not an ip"
      ].each { |v| expect_invalid(v) }
    end

    it "rejects non-string values" do
      expect_invalid(12345)
      expect_invalid(:not_a_string)
      expect_invalid([])
    end
  end

  describe "IPv6" do
    it "accepts well-formed IPv6 addresses" do
      %w[
        ::1
        ::
        fe80::1
        2001:db8::1
        2001:0db8:85a3:0000:0000:8a2e:0370:7334
        ::ffff:192.0.2.128
      ].each { |v| expect_valid(v) }
    end

    it "rejects malformed IPv6 addresses" do
      %w[
        gggg::1
        2001:db8:::1
        12345::1
      ].each { |v| expect_invalid(v) }
      expect_invalid("not even close")
    end
  end

  describe ":ipv4_only" do
    it "accepts IPv4 and rejects IPv6" do
      expect_valid("10.0.0.1", ipv4_only: true)
      expect_invalid("::1", ipv4_only: true)
      expect_invalid("2001:db8::1", ipv4_only: true)
    end
  end

  describe ":ipv6_only" do
    it "accepts IPv6 and rejects IPv4" do
      expect_valid("::1", ipv6_only: true)
      expect_invalid("10.0.0.1", ipv6_only: true)
    end
  end

  describe ":allow_nil" do
    it "permits nil only when set" do
      expect_invalid(nil)
      m = model_class(allow_nil: true).new
      m.ip = nil
      expect(m).to be_valid
    end
  end

  describe ":allow_blank" do
    it "permits blank only when set" do
      expect_invalid("")
      m = model_class(allow_blank: true).new
      m.ip = ""
      expect(m).to be_valid
    end
  end

  describe "CIDR" do
    it "rejects CIDR notation by default" do
      expect_invalid("10.0.0.0/24")
      expect_invalid("2001:db8::/32")
      expect_invalid("0.0.0.0/0")
    end

    it "accepts CIDR notation when :allow_cidr is true" do
      expect_valid("10.0.0.0/24", allow_cidr: true)
      expect_valid("2001:db8::/32", allow_cidr: true)
    end

    it "still rejects garbage even with :allow_cidr" do
      expect_invalid("not/cidr", allow_cidr: true)
      expect_invalid("10.0.0.0/99", allow_cidr: true)
    end
  end

  describe ":no_loopback" do
    it "rejects IPv4 loopback addresses" do
      expect_invalid("127.0.0.1", no_loopback: true)
      expect_invalid("127.1.2.3", no_loopback: true)
    end

    it "rejects IPv6 loopback" do
      expect_invalid("::1", no_loopback: true)
    end

    it "still allows non-loopback addresses" do
      expect_valid("8.8.8.8", no_loopback: true)
      expect_valid("2001:db8::1", no_loopback: true)
    end
  end

  describe ":no_private" do
    it "rejects RFC 1918 IPv4 ranges" do
      %w[10.0.0.1 172.16.5.4 192.168.1.1].each { |v| expect_invalid(v, no_private: true) }
    end

    it "rejects IPv6 unique local addresses" do
      expect_invalid("fc00::1", no_private: true)
      expect_invalid("fd12:3456:789a::1", no_private: true)
    end

    it "permits public addresses" do
      expect_valid("8.8.8.8", no_private: true)
      expect_valid("2001:4860:4860::8888", no_private: true)
    end
  end

  describe ":no_reserved" do
    it "rejects link-local addresses" do
      expect_invalid("169.254.1.1", no_reserved: true)
      expect_invalid("fe80::1", no_reserved: true)
    end

    it "rejects multicast and broadcast" do
      expect_invalid("224.0.0.1", no_reserved: true)
      expect_invalid("255.255.255.255", no_reserved: true)
      expect_invalid("ff02::1", no_reserved: true)
    end

    it "rejects the documentation prefix (2001:db8::/32)" do
      expect_invalid("2001:db8::1", no_reserved: true)
    end

    it "permits ordinary public addresses" do
      expect_valid("8.8.8.8", no_reserved: true)
      expect_valid("2606:4700:4700::1111", no_reserved: true)
    end
  end

  describe "IPv4-mapped IPv6" do
    it "accepts ::ffff:0:0/96 form by default" do
      expect_valid("::ffff:192.0.2.128")
    end

    it "is treated as IPv6 (not IPv4) for :ipv4_only" do
      # IPAddr reports this as IPv6, so :ipv4_only rejects it.
      expect_invalid("::ffff:192.0.2.128", ipv4_only: true)
    end

    it "is accepted under :ipv6_only" do
      expect_valid("::ffff:192.0.2.128", ipv6_only: true)
    end
  end

  describe ":message" do
    it "uses a custom message when validation fails" do
      m = model_class(message: "isn't a real IP address").new
      m.ip = "garbage"
      expect(m).not_to be_valid
      expect(m.errors[:ip]).to include("isn't a real IP address")
    end
  end

  describe "default error key" do
    it "uses :invalid_ip" do
      expect(described_class.error_key).to eq(:invalid_ip)
    end
  end

  describe "VERSION" do
    it "is defined as a string" do
      expect(IpAddressValidator::VERSION).to be_a(String)
      expect(IpAddressValidator::VERSION).to match(/\A\d+\.\d+\.\d+/)
    end
  end
end
