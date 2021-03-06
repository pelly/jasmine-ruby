require 'rubygems'
require "selenium_rc"
require File.expand_path(File.join(File.dirname(__FILE__), "jasmine_helper.rb"))
helper_overrides = File.expand_path(File.join(Dir.pwd, "spec", "helpers", "jasmine_helper.rb"))
if File.exist?(helper_overrides)
  require helper_overrides
end
require File.expand_path(File.join(File.dirname(__FILE__), "jasmine_runner.rb"))
require File.expand_path(File.join(File.dirname(__FILE__), "jasmine_spec_builder"))

jasmine_runner = Jasmine::Runner.new(SeleniumRC::Server.new.jar_path,
                                     Dir.pwd,
                                     JasmineHelper.specs,
                                     { :spec_helpers => JasmineHelper.files + JasmineHelper.spec_helpers,
                                       :stylesheets => JasmineHelper.stylesheets
                                     })

spec_builder = Jasmine::SpecBuilder.new(JasmineHelper.spec_files, jasmine_runner)

should_stop = false

Spec::Runner.configure do |config|
  config.after(:suite) do
    spec_builder.stop if should_stop
  end
end

spec_builder.start
should_stop = true
spec_builder.declare_suites