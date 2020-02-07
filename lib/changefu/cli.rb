require 'thor'
require 'tty-table'
require 'changefu/actions'
require 'changefu/changelog'
require 'changefu/configuration'

module Changefu
  class CLI < Thor
    include Thor::Actions
    include Actions

    package_name 'Changefu'
    default_task :help

    def self.source_root
      File.expand_path('../../templates', __dir__)
    end

    def self.exit_on_failure?
      true
    end

    desc 'add TITLE', 'Adds a new entry to changelog using this title'
    option :type, type: :string, default: 'added'
    option :username, type: :string
    option :issue, type: :string
    def add(title)
      require_changefu!

      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      template 'change.tt',
               "changelog/unreleased/#{timestamp}_#{title.parameterize(separator: '_')}.yml",
               options.merge(title: title, username: username, issue: issue)
    end

    desc 'generate', 'Generates changelog files'
    option :markdown, type: :boolean
    option :json, type: :boolean
    option 'markdown-filename', type: :string
    option 'json-filename', type: :string
    def generate
      require_changefu!
      generate_changelog!
    end

    desc 'release VERSION', 'Releases a new version and generates changelog files'
    option :date, type: :string
    option :tag, type: :string
    option :generate, type: :boolean, default: true
    option :markdown, type: :boolean
    option :json, type: :boolean
    option 'markdown-filename', type: :string
    option 'json-filename', type: :string
    def release(version)
      require_changefu!

      # release new version
      Changefu::Changelog.release!(version, options[:date], options[:tag])

      # generate changelog
      generate_changelog! if options[:generate]
    end

    desc 'releases', 'List of releases'
    def releases
      require_changefu!

      list = Changefu::Changelog.releases.map(&:to_table_row)

      if list.count.positive?
        $stdout.puts TTY::Table.new(
          %w[Release Date Tag], list
        ).render(:ascii, padding: [0, 1, 0, 1])
      else
        warn 'No releases found in `changelog/releases.yml` file'
      end
    end

    desc 'setup', 'Installs Changefu in this folder'
    def setup
      # create the changelog directory
      empty_directory 'changelog'
      empty_directory 'changelog/releases'
      empty_directory 'changelog/unreleased'
      create_file 'changelog/releases/.keep'
      create_file 'changelog/unreleased/.keep'
      create_file 'changelog/releases.yml', '---'

      # add the configuration file
      copy_file 'changefu.yml', '.changefu.yml'
    end

    map %w[--version -v] => :app_version
    desc '--version, -v', 'Prints the version'
    def app_version
      $stdout.puts Changefu.version
    end

    private

    def generate_changelog!
      if option_markdown
        Changefu::Changelog.generate!(:markdown, option_markdown_filename)
        say_status :created, option_markdown_filename
      end

      return unless option_json

      Changefu::Changelog.generate!(:json, option_json_filename)
      say_status :created, option_json_filename
    end

    def option_markdown
      default = Changefu::Configuration.formats.try(:[], :markdown) || false
      options.key?('markdown') ? options['markdown'] : default
    end

    def option_json
      default = Changefu::Configuration.formats.try(:[], :json) || false
      options.key?('json') ? options['json'] : default
    end

    def option_markdown_filename
      default = Changefu::Configuration.filenames.try(:[], :markdown) || 'CHANGELOG.md'
      options.key?('markdown-filename') ? options['markdown-filename'] : default
    end

    def option_json_filename
      default = Changefu::Configuration.filenames.try(:[], :json) || '.changelog.json'
      options.key?('json-filename') ? options['json-filename'] : default
    end
  end
end
