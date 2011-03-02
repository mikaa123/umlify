def growl(message)
  growlnotify = `which growlnotify`.chomp
  title = "Watchr Test Results"
  passed = message.include?('0 failures, 0 errors')
  severity = passed ? "-1" : "1"
  options = "-w -n Watchr"
  options << " -m '#{message}' '#{title}' -p #{severity}"
  system %(#{growlnotify} #{options} &)
end

def run_all_tests
  system('clear')
  result = `rake test`
  growl result.split("\n")[-3] rescue nil
  puts result
end

watch("test/.*_test\.rb") do
  run_all_tests
end

watch("lib/.*\.rb") do
  run_all_tests
end
