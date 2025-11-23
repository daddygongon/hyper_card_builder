# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "hyper_card_builder"

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require "minitest/autorun"
