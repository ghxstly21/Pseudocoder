#!/usr/bin/env ruby

require_relative "app/services/compiler/compiler.rb"

# Test the JavaScript compiler with the test file
test_file = "test/compiler_tests/js_function.js"

puts "Testing JavaScript compiler with: #{test_file}"
puts "=" * 60

begin
  start_time = Time.now
  pseudocode = Compiler.compile(test_file, from_file: true)
  elapsed = Time.now - start_time

  puts "✓ SUCCESS! Compilation completed in #{elapsed.round(3)} seconds"
  puts "=" * 60
  puts "Generated Pseudocode:"
  puts "=" * 60
  puts pseudocode
  puts "=" * 60
  puts "\n✓ All features compiled successfully!"
rescue => e
  puts "✗ ERROR during compilation:"
  puts e.class
  puts e.message
  puts e.backtrace.first(10).join("\n")
end
