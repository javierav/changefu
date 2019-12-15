module Changefu
  class Changelog
    include Enumerable

    def each(&block)
      if block_given?
        block.call
      else
        to_enum(:each)
      end
    end

    def render_template

    end
  end
end
