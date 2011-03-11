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

    should "print the api url when passed -h or --html option"  do
      r = Umlify::Runner.new(["-h"])
      r.run
      assert r.html_mode
      r = Umlify::Runner.new(["--html"])
      r.run
      assert r.html_mode
    end
  end
end

