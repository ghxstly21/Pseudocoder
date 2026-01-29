desc "Check the entire app using RuboCop & Steep"
task :check do
  abort "RuboCop failed..." unless system "bundle exec rubocop -a", out: $stdout, err: :out
  abort "Steep checking failed..." unless system "bundle exec steep check app", out: $stdout, err: :out
end
