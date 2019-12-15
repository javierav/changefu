require 'date'
require 'yaml'

module Changefu
  # Represents every release in the changelog
  class Release
    attr_accessor :version, :date, :tag

    def initialize(options)
      @version = options.fetch(:version)
      @date    = options.fetch(:date)
      @tag     = options.fetch(:tag)
    end

    # Returns an array of releases
    def self.all
      # read releases.yml file
      releases = YAML.safe_load(
        File.read(Changefu.get_file('changelog/releases.yml')),
        symbolize_names: true, permitted_classes: [Date]
      )

      releases[:releases].map do |release|
        Release.new(release)
      end
    end

    def to_table_row
      [version, date, tag]
    end
  end
end
