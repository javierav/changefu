require 'yaml'

module Changefu
  class Change
    attr_accessor :timestamp, :type, :title, :username, :issue, :path

    def self.from_file(path)
      data = YAML.safe_load(File.read(path), symbolize_names: true)
      timestamp = path.basename('.yml').to_s.split('_').first

      new(
        type: data.fetch(:type),
        title: data.fetch(:title),
        username: data.fetch(:username),
        issue: data.fetch(:issue),
        timestamp: timestamp,
        path: path
      )
    end

    def initialize(attributes={})
      attributes.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def issue_to_markdown
      url = Changefu::Configuration.issue_url

      return unless url

      "[##{issue}](#{url.sub('{issue}', issue.to_s)})"
    end

    def username_to_markdown
      url = Changefu::Configuration.username_url

      return unless url

      "([#{username}](#{url.sub('{username}', username)}))"
    end

    def to_hash
      {title: title, username: username, issue: issue}
    end
  end
end
