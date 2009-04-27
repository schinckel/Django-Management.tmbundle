#! /usr/bin/env ruby

# Open the site in a browser?

Dir.chdir ENV['TM_PROJECT_DIRECTORY']

command = [ENV["TM_PYTHON"] || "python", "-u", "manage.py"] + ($* or ["runserver"])

require ENV["TM_SUPPORT_PATH"] + "/lib/tm/executor"

# print a button to allow for stopping the server

TextMate::Executor.run(command) do |str, type|
  if str =~ /\[.*\]\s\".*\"\s(\d+)\s\d+/
  	code = $1
  	cls = (code.to_i >= 400 ? "err" : "ok") 
  	str = "<div class=\"#{cls}\">#{str}</div>"
	end
	str
end