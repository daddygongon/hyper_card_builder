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

    desc "split [YAML_FILE]", "Split PDF according to YAML_FILE (default: hc_array.yaml) and save to target_dir"
    def split(yaml_file = "hc_array.yaml")
      require "fileutils"
      require "yaml"

      data = YAML.load(File.read(yaml_file))
      source_file = data[:source_file] || "./linux_basic.pdf"
      target_dir = data[:target_dir] || "linux_basic"
      FileUtils.mkdir_p(target_dir) unless Dir.exist?(target_dir)

      data[:toc].each do |v|
        init = v[:init]
        fin = v[:fin]
        pages = if fin.nil?
                  fin = init
                  "#{init}"
                else
                  "#{init}-#{fin}"
                end
        o_file = [v[:no], v[:head], pages].compact.join('_') + ".pdf"
        target = File.join(target_dir, o_file)
        comm = "qpdf #{source_file} --pages . #{init}-#{fin} -- #{target}"
        puts comm
        system(comm)
      end
    end

    desc "split without pages [YAML_FILE]", "Split PDF wo pages according to YAML_FILE (default: hc_array.yaml) and save to target_dir"
    def split_wo_pages(yaml_file = "hc_array.yaml")
      require "fileutils"
      require "yaml"

      data = YAML.load(File.read(yaml_file))
      source_file = data[:source_file] || "./linux_basic.pdf"
      target_dir = data[:target_dir] || "linux_basic"
      FileUtils.mkdir_p(target_dir) unless Dir.exist?(target_dir)

      data[:toc].each do |v|
        init = v[:init]
        fin = v[:fin]
        pages = if fin.nil?
                  fin = init
                  "#{init}"
                else
                  "#{init}-#{fin}"
                end
        o_file = [v[:no], v[:head]].compact.join('_') + ".pdf"
        target = File.join(target_dir, o_file)
        p target
        comm = "qpdf #{source_file} --pages . #{init}-#{fin} -- #{target}"
        puts comm
        system(comm)
      end
    end

  end
end
