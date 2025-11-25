# test/test_linux_basic_split_test.rb
# frozen_string_literal: true

require "test_helper"
require "fileutils"
require "open3"
require "yaml"

class TestLinuxBasicSplit < Minitest::Test
  TEST_ENV_DIR   = File.expand_path("../test_env", __dir__)
  LINUX_BASIC_PDF_SRC = File.expand_path("./linux_basic.pdf", __dir__)
  LINUX_BASIC_PDF     = File.join(TEST_ENV_DIR, "linux_basic.pdf")
  YAML_CONFIG         = File.join(TEST_ENV_DIR, "linux_basic.yaml")
  YAML_FILE           = File.join(TEST_ENV_DIR, "hc_array.yaml")
  OUTPUT_DIR          = File.join(TEST_ENV_DIR, "linux_basic")

  def setup
    FileUtils.rm_rf(TEST_ENV_DIR)
    FileUtils.mkdir_p(TEST_ENV_DIR)
    FileUtils.cp(LINUX_BASIC_PDF_SRC, LINUX_BASIC_PDF)
    # サンプルYAMLを作成
    yaml_data = {
      source_file: "./linux_basic.pdf",
      target_dir: "./linux_basic",
      toc: [
        { no: nil, init: 1, fin: nil, head: "title" },
        { no: "s0", init: 2, fin: nil, head: "commands" },
        { no: "sf", init: 8, fin: 8, head: "summary" }
      ]
    }
    File.write(YAML_FILE, yaml_data.to_yaml)
  end

  def teardown
#   FileUtils.rm_rf(TEST_ENV_DIR)
  end

  def test_split_linux_basic_pdf_by_yaml
    exe_path = File.expand_path("../exe/hyper_card_builder", __dir__)
    Dir.chdir(TEST_ENV_DIR) do
      cmd = [
        "bundle", "exec", exe_path,
        "split"
        # PDF_FILEもYAML_FILEも省略（デフォルトでhc_array.yamlを使う）
      ]
      output, status = Open3.capture2(*cmd)
      assert status.success?, "CLI did not exit successfully: #{output}"

      yaml_sections = YAML.load_file("hc_array.yaml")
      target_dir = yaml_sections[:target_dir] || "linux_basic"
      assert Dir.exist?(target_dir), "Output directory not created"

      yaml_sections[:toc].each do |section|
        pages = section[:fin].nil? ? "#{section[:init]}" : "#{section[:init]}-#{section[:fin]}"
        filename = [section[:no], section[:head], pages].compact.join('_') + ".pdf"
        filepath = File.join(target_dir, filename)
        assert File.exist?(filepath), "Expected file #{filepath} not found"
      end
    end
  end
end