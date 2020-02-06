require 'fileutils'
require 'changefu/change'
require 'changefu/changes_group'

module Changefu
  class Release
    attr_accessor :version, :date, :tag

    def initialize(version, date, tag)
      @version = version
      @date = date.is_a?(Date) ? date.strftime('%Y-%m-%d') : date
      @tag = tag
    end

    # List of changes for this release
    def changes
      @changes ||= path.glob('*.yml').map { |f| Changefu::Change.from_file(f) }.sort_by(&:timestamp)
    end

    # List of changes grouped by type
    def changes_by_type
      @changes_by_type ||= changes.group_by(&:type).map { |g|
        ChangesGroup.new(g.first, g.last)
      }.sort_by(&:type)
    end

    # Path to the release folder with the changes
    def path
      Changefu.path_helper("changelog/releases/#{version}")
    end

    def to_table_row
      [version, date, tag]
    end

    def create_dir
      FileUtils.mkdir(path) unless path.exist?
    end

    def to_yaml_hash
      {'version' => version, 'date' => date, 'tag' => tag}
    end

    def to_hash
      changes_hash = {}

      changes_by_type.each do |group|
        changes_hash[group.type] = group.changes.map(&:to_hash)
      end

      {version: version, date: date, tag: tag, changes: changes_hash}
    end
  end
end
