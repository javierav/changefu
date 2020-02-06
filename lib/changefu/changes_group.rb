module Changefu
  class ChangesGroup
    attr_reader :type, :changes

    def initialize(type, changes=[])
      @type = type
      @changes = changes
    end

    def humanized_name
      if Changefu::Configuration.respond_to?(:types)
        Changefu::Configuration.types[type.to_sym] || type.capitalize
      else
        type.capitalize
      end
    end
  end
end
