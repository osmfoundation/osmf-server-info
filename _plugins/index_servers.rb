# frozen_string_literal: true

# Builds the server lists for hardware index rows, sorted by server name.

class IndexServers
  def self.counted(entries)
    entries
      .sort_by { |entry| entry[:server] }
      .map { |entry| { "name" => entry[:server], "count" => entry[:count] } }
  end

  def self.names(entries)
    entries.map { |entry| entry[:server] }.sort
  end
end
