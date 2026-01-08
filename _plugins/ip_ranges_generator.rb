# frozen_string_literal: true

require "ipaddr"
require "fileutils"
require "time"

module Jekyll
  # Generates a plaintext list of external IP ranges pulled from nodes data.
  class GeneratedFile < StaticFile
    def initialize(site, base, dir, name, content)
      @content = content
      super(site, base, dir, name)
    end

    # rubocop:disable Naming/PredicateMethod
    def write(dest)
      dest_path = destination(dest)
      FileUtils.mkdir_p(File.dirname(dest_path))
      File.write(dest_path, @content)
      true
    end
    # rubocop:enable Naming/PredicateMethod
  end

  class IPRangesGenerator < Generator
    safe true
    priority :low

    MULTICAST_IPV4 = IPAddr.new("224.0.0.0/4")
    MULTICAST_IPV6 = IPAddr.new("ff00::/8")
    UNSPECIFIED_IPV4 = IPAddr.new("0.0.0.0")
    UNSPECIFIED_IPV6 = IPAddr.new("::")

    def generate(site)
      ranges = extract_ranges(site.data["nodes"])
      return if ranges.empty?

      content = format_ranges(ranges)
      site.static_files << GeneratedFile.new(site, site.source, "", "ip-ranges.txt", content)
    end

    private

    def extract_ranges(nodes)
      return [] unless nodes && nodes["rows"]

      nodes["rows"]
        .flat_map { |node| external_ranges(node) }
        .compact
        .uniq
        .then { |ranges| sort_ranges(ranges) }
    end

    def external_ranges(node)
      interfaces = node.dig("default", "networking", "interfaces")
      return [] unless interfaces

      hosted_by = node.dig("default", "hosted_by")

      interfaces.values.flat_map do |interface|
        next [] unless interface["role"] == "external"

        ipv4 = cidr_from(interface["inet"], hosted_by)
        ipv6 = cidr_from(interface["inet6"], hosted_by)

        [ipv4, ipv6].compact
      end
    end

    def cidr_from(details, hosted_by = nil)
      ip, prefix = ip_and_prefix(details, hosted_by)
      return unless ip && prefix

      return unless public_unicast?(ip)

      network = ip.mask(prefix)
      "#{network}/#{prefix}"
    rescue IPAddr::InvalidAddressError
      nil
    end

    def ip_and_prefix(details, hosted_by = nil)
      return [nil, nil] unless details

      ip_string = details["public_address"] || details["address"]
      return [nil, nil] unless ip_string

      ip = IPAddr.new(ip_string)
      prefix = host_prefix_needed?(hosted_by, details) ? host_prefix(ip) : details["prefix"].to_i

      prefix.positive? ? [ip, prefix] : [nil, nil]
    end

    def host_prefix_needed?(hosted_by, details)
      hosted_by || details["public_address"]
    end

    def host_prefix(ip)
      ip.ipv4? ? 32 : 128
    end

    def public_unicast?(ip)
      !ip.private? &&
        !ip.loopback? &&
        !ip.link_local? &&
        !multicast?(ip) &&
        !unspecified?(ip)
    end

    def multicast?(ip)
      ip.ipv4? ? MULTICAST_IPV4.include?(ip) : MULTICAST_IPV6.include?(ip)
    end

    def unspecified?(ip)
      ip.ipv4? ? UNSPECIFIED_IPV4.include?(ip) : UNSPECIFIED_IPV6.include?(ip)
    end

    def format_ranges(ranges)
      lines = [
        "# External IP ranges for OpenStreetMap servers",
        "# Generated at #{Time.now.utc.iso8601} UTC",
        "#",
        "# Note: Services are often fronted by Fastly.",
        "# See: https://api.fastly.com/public-ip-list",
        "#"
      ]

      "#{(lines + ranges).join("\n")}\n"
    end

    def sort_ranges(ranges)
      ranges.sort_by do |cidr|
        ip = IPAddr.new(cidr.split("/").first)
        family = ip.ipv4? ? 0 : 1
        [family, ip.to_i]
      rescue IPAddr::InvalidAddressError
        [2, cidr]
      end
    end
  end
end
