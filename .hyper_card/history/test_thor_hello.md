daddygongon: bundle exec exe/hyper_card_builder helloで"Hello."と返るテストを作成．

Workspace: **Pseudocode Plan:**
1. Require necessary test helper.
2. Define a test class inheriting from `Minitest::Test`.
3. Write a test to check that running `bundle exec exe/hyper_card_builder hello` returns `"Hello.\n"` and exits successfully.
4. Optionally, add basic sanity tests (version number, etc.) if needed.

**Code:**

```ruby
# test/test_hyper_card_builder_test.rb
# frozen_string_literal: true

require "test_helper"

class TestHyperCardBuilderTest < Minitest::Test
  def test_exe_hello_outputs_hello_dot
    require "open3"
    output, status = Open3.capture2("bundle exec exe/hyper_card_builder hello")
    assert_equal "Hello.\n", output
    assert status.success?
  end
end
```

daddygongon: Thorを使ってcommand cliでhelloを受け取るように修正

GitHub Copilot: ````ruby
# frozen_string_literal: true

require_relative "hyper_card_builder/version"
require "thor"

module HyperCardBuilder
  class Error < StandardError; end

  class CLI < Thor
    desc "hello", "Prints Hello."
    def hello
      puts "Hello."
    end
  end
end
````

````ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/hyper_card_builder"

HyperCardBuilder::CLI.start(ARGV)
````

daddygongon: ThorのCLIが起動するように修正．

GitHub Copilot: ````ruby
#!/usr/bin/env ruby

require "hyper_card_builder"

HyperCardBuilder::CLI.start(ARGV)
````