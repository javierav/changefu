require 'pathname'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string'
require 'active_support/json'

module Changefu
  def self.path_helper(path)
    Pathname.pwd.join(path)
  end

  def self.path_helper!(path)
    path = path_helper(path)

    return path if path.exist?

    abort "File #{path} cannot be found!" if path.file?
    abort "Directory #{path} cannot be found!" if path.directory?
  end
end

require 'changefu/cli'
require 'changefu/version'
