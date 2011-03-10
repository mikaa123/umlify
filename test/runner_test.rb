require 'shoulda'
require 'umlify'

class RunnerTest < Test::Unit::TestCase

  context "Runner" do

    should "be in smart mode when passed -s or --smart as an option"  do
      r = Umlify::Runner.new(["-s"])
      r.run
      assert r.smart_mode
      r = Umlify::Runner.new(["--smart"])
      r.run
      assert r.smart_mode
    end

  end
end

