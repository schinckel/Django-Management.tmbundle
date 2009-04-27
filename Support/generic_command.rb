#! /usr/bin/env ruby

# Open the site in a browser?

Dir.chdir ENV['TM_PROJECT_DIRECTORY']

command = [ENV["TM_PYTHON"] || "python", "-u", "manage.py"] + $*

require ENV["TM_SUPPORT_PATH"] + "/lib/tm/executor"

TextMate::Executor.run(command) do |str, type|
  "<div class=\"#{type}\">#{str}</div>"
end