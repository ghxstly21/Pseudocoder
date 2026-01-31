require_relative("../app/services/compiler/compiler.rb")

SUPPORTED_LANGUAGES = %w[.java .js .py]
pseudocode = nil

def normalize_path(path)
  path.strip!
  if (path.start_with?('"') && path.end_with?('"')) ||
     (path.start_with?("'") && path.end_with?("'"))
    path = path[1..-2] # remove first and last char
  end
  path
end

def is_valid?(path)
  File.exist?(path) && SUPPORTED_LANGUAGES.include?(File.extname(path))
end

puts "Welcome to Pseudocoder!"
puts "Your source file will be compiled into English-readable pseudocode."
puts "Java, JavaScript, and Python files are supported."
print "1. File input\n2. Copy and pasted code input\nChoose an option: "
input = gets.to_s.strip
until %w[1 2].include? input
  print "Invalid input. Please reenter your choice: "
  input = gets.to_s.strip
end
case input
when "1"
  print "Please enter a file path: "

  file = normalize_path(gets.chomp)

  until is_valid? file
    puts file.inspect
    puts "The file you entered could not be found on your computer." unless File.exist?(file)
    puts "The file you entered is not one of our supported languages. (Java, JavaScript, Python)" unless SUPPORTED_LANGUAGES.include?(File.extname(file))
    print "Please reenter the file path: "
    file = normalize_path(gets.chomp)
  end
  puts "File is valid!\nCompiling..."

  elapsed = Compiler.time { pseudocode = Compiler.compile_file file }

when "2"
  puts "Paste your code below:"
  code = gets.chomp
  elapsed = Compiler.time { pseudocode = Compiler.compile_text code }
else
  raise "Unexpected input: #{input.inspect}.\nExpected '1' or '2'."
end

puts "Finished compiling in #{elapsed} seconds.\nYour file in pseudocode:"
puts pseudocode
