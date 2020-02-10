require 'pathname'

module FixturesHelper
  def fixture_path(file)
    Pathname.new(__dir__).join('../fixtures').join(file)
  end
end

RSpec.configure do |config|
  config.include FixturesHelper
end
