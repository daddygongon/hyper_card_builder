# frozen_string_literal: true

require "test_helper"

class TestHyperCardBuilderTest < Minitest::Test
  def test_exe_hello_outputs_hello_dot
    require "open3"
    output, status = Open3.capture2("bundle exec exe/hyper_card_builder hello")
    assert_equal "Hello.\n", output
    assert status.success?
  end

  def test_that_it_has_a_version_number
    refute_nil ::HyperCardBuilder::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

=begin
  def test_exe_outputs_hello
    require "open3"
    output, status = Open3.capture2("bundle exec exe/hyper_card_builder")
    assert_equal "Hello\n", output
    assert status.success?
  end
=end
end
