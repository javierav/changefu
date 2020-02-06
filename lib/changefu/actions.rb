module Changefu
  module Actions
    def cf_root(path=nil)
      @cf_root ||= begin
        if path.nil?
          cf_root(Pathname.pwd)
        elsif path.join('changelog').exist?
          path
        else
          path.root? ? nil : cf_root(path.parent)
        end
      end
    end

    def require_changefu!
      if !cf_root
        abort <<~TEXT
          This project does not use ChangeFu. Please run `changefu setup` first on the project root!
        TEXT
      elsif cf_root && cf_root != Pathname.pwd
        abort 'You must run this command from the root folder of the project!'
      end
    end
  end
end
