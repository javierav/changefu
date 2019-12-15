module Changefu
  # This class represents an entry in the changelog
  #
  # @since 0.0.1
  class Change
    # @return [Symbol] the type of the changelog entry
    attr_reader :type

    # @return [String] the title of the changelog entry
    attr_reader :title

    # @return [String] the name of the author of the changelog entry
    attr_reader :author_name

    # @return [String] the username of the author of the changelog entry
    attr_reader :author_username

    def initialize(params={})
      @type = params.fetch(:title, :added).to_sym
      @title = params.fetch(:title)
      @author_name = params.fetch(:author_name)
      @author_username = params.fetch(:author_username)
    end
  end
end
