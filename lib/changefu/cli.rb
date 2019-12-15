require 'thor'
require 'tty-table'

module Changefu
  class CLI < Thor
    include Thor::Actions

    package_name 'Changefu'
    default_task :help

    def self.source_root
      File.expand_path('../../templates', __dir__)
    end

    desc 'add TITLE', 'Add a new entry to the changelog using this title'
    option :type, type: :string, default: 'add'
    def add(title)
      puts title.inspect
    end

    desc 'generate', 'Generate the changelog file'
    option :author, type: :boolean, default: true
    option :format, type: :string, default: :json
    option :language, type: :string, default: :en
    def generate
    end

    desc 'release VERSION', 'Release a new version and generate the changelog file'
    option :author, type: :boolean, default: true
    option :date, type: :string
    option :format, type: :string, default: 'json'
    option :generate, type: :boolean, default: true
    option :language, type: :string, default: 'en'
    option :tag, type: :string
    def release
    end

    desc 'releases', 'List of releases'
    def releases
      $stdout.puts TTY::Table.new(
        %w[Release Date Tag], Changefu::Release.all.map(&:to_table_row)
      ).render(:ascii, padding: [0, 1, 0, 1])
    end

    desc 'setup', 'Install Changefu in this folder'
    def setup
      # create the changelog directory
      empty_directory 'changelog'
      empty_directory 'changelog/releases'
      empty_directory 'changelog/unreleased'
      create_file 'changelog/releases/.keep'
      create_file 'changelog/unreleased/.keep'
      create_file 'changelog/releases.yml', 'releases:'

      # add the configuration file
      copy_file 'changefu.yml', '.changefu.yml'
    end

    map %w[--version -v] => :app_version
    desc '--version, -v', 'Print the version'
    def app_version
      $stdout.puts Changefu.version
    end
  end
end
