# frozen_string_literal: true

require_relative "hyper_card_builder/version"
require "thor"
require "yaml" # ← 追加

module HyperCardBuilder
  class Error < StandardError; end

  class CLI < Thor
    desc "hello", "Prints Hello."
    def hello
      puts "Hello."
    end

    desc "puts_hc_array", "Outputs hc_array.yaml"
    def puts_hc_array
      hc_array = {
        source_file: "./linux_basic.pdf",
        target_dir: "./linux_basic",
        toc: [
          { no: nil, init: 1, fin: nil, head: "title" },
          { no: "s0", init: 2, fin: nil, head: "commands" },
          { no: "sf", init: 8, fin: 8, head: "summary" }
        ]
      }
      File.open("hc_array.yaml", "w") { |f| f.write(hc_array.to_yaml) }
      puts "hc_array.yaml generated."
    end
  end
end
