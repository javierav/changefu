require 'erb'
require 'fileutils'
require 'ostruct'
require 'pathname'
require 'yaml'
require 'changefu/configuration'
require 'changefu/changes_group'
require 'changefu/release'

module Changefu
  class Changelog
    # Generate the changelog
    def self.generate!(format, filename)
      new.send("generate_#{format}", filename)
    end

    def self.release!(version, date=nil, tag=nil)
      date ||= Time.now.strftime('%Y-%m-%d')
      tag  ||= "v#{version}"

      new.release(version, date, tag)
    end

    def self.releases
      new.releases
    end

    # List of releases
    def releases
      @releases ||= (
        YAML.safe_load(
          File.read(Changefu.path_helper!('changelog/releases.yml')),
          symbolize_names: true, permitted_classes: [Date]
        ) || []
      ).map { |release|
        Changefu::Release.new(release[:version], release[:date], release[:tag])
      }.sort_by(&:date).reverse
    end

    # List of unreleased changes
    def unreleased_changes
      unreleased_path.glob('*.yml').map { |f| Changefu::Change.from_file(f) }.sort_by(&:timestamp)
    end

    # List of unreleased changes group by type
    def unreleased_changes_by_type
      unreleased_changes.group_by(&:type).map { |g|
        ChangesGroup.new(g.first, g.last)
      }.sort_by(&:type)
    end

    # Release a new version
    def release(version, date, tag)
      abort "Version #{version} already exists!" if releases.any? { |r| r.version == version }

      # create new release
      new_release = Changefu::Release.new(version, date, tag)

      # create new release directory
      new_release.create_dir

      # compose new releases array
      new_releases_list = (releases + [new_release]).map(&:to_yaml_hash)

      # update releases.yml file
      save_file(new_releases_list.to_yaml, 'changelog/releases.yml')

      # move changes files from unreleased
      Changefu.path_helper('changelog/unreleased').glob('*.yml').each do |file|
        move_file(file, new_release.path)
      end

      # reset releases list to force reload next time
      @releases = nil
    end

    def generate_markdown(filename)
      template = ERB.new(File.read(templates_path.join('changelog.markdown.erb')), trim_mode: '>')
      output = template.result(context.instance_eval { binding })
      save_file(output, filename)
    end

    def generate_json(filename)
      template = ERB.new(File.read(templates_path.join('changelog.json.erb')), trim_mode: '>')
      output = template.result(context.instance_eval { binding })
      save_file(output, filename)
    end

    private

    def move_file(origin, destination)
      if Changefu::Configuration.use_git_mv
        system("git mv #{origin} #{destination} 2> /dev/null")

        return if $?.success?
      end

      FileUtils.mv(origin, destination)
    end

    def save_file(content, path)
      File.open(Changefu.path_helper(path), 'w') do |file|
        file.write(content)
      end
    end

    def templates_path
      Pathname.new(__dir__).join('../../templates')
    end

    def unreleased_path
      Changefu.path_helper('changelog/unreleased')
    end

    def context
      OpenStruct.new(
        header: Changefu::Configuration.header,
        footer: Changefu::Configuration.footer,
        unreleased: unreleased_changes_by_type,
        include_unreleased: Changefu::Configuration.include_unreleased,
        releases: releases
      )
    end
  end
end
