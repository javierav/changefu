require 'pathname'
require 'changefu/cli'
require 'changefu/configuration'
require 'changefu/release'
require 'changefu/version'

module Changefu
  def self.get_file(path)
    file_path = Pathname.pwd.join(path)

    unless file_path.exist?
      abort 'You must execute Changefu from the root directory of the project!'
    end

    file_path
  end
end
