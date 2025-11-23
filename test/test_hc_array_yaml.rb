# frozen_string_literal: true

require "test_helper"
require "yaml"
require "fileutils"
require "minitest/hooks/default"

class TestHcArrayYaml < Minitest::Test
  include Minitest::Hooks

  TEST_ENV_DIR = File.expand_path("../test_env", __dir__)
  GENERATED_FILE = File.join(TEST_ENV_DIR, "hc_array.yaml")
  EXPECTED_YAML = {
    source_file: "./linux_basic.pdf",
    target_dir: "./linux_basic",
    toc: [
      { no: nil, init: 1, fin: nil, head: "title" },
      { no: "s0", init: 2, fin: nil, head: "commands" },
      { no: "sf", init: 8, fin: 8, head: "summary" }
    ]
  }

  def before_all
    FileUtils.rm_rf(TEST_ENV_DIR)
    FileUtils.mkdir_p(TEST_ENV_DIR)
  end

  def after_all
    FileUtils.rm_rf(TEST_ENV_DIR)
  end

  def test_puts_hc_array_outputs_expected_yaml
    exe_path = File.expand_path("../exe/hyper_card_builder", __dir__)
    Dir.chdir(TEST_ENV_DIR) do
      require "open3"
      output, status = Open3.capture2("bundle exec #{exe_path} puts_hc_array")
      assert status.success?, "Command failed: #{output}"

      assert File.exist?(GENERATED_FILE), "Expected #{GENERATED_FILE} to be generated"

      actual_yaml = YAML.load_file(GENERATED_FILE)
      assert_equal EXPECTED_YAML, actual_yaml
    end
  end
end
