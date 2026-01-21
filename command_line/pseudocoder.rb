require_relative("../app/services/compiler/compiler.rb")

SUPPORTED_LANGUAGES = %w[.java .js .py]



def to_path(path)
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
print "Please enter a file path: "

file = to_path(gets.chomp)

until is_valid?(file)
  puts file.inspect
    puts "The file you entered could not be found on your computer." unless File.exist?(file)
    puts "The file you entered is not one of our supported languages. (Java, JavaScript, Python)" unless SUPPORTED_LANGUAGES.include?(File.extname(file))
    print "Please reenter the file path: "
    file = gets.chomp
end
puts "File is valid"
# Compiler::Compiler.compile(file)
