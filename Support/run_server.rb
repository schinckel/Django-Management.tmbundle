#! /usr/bin/env ruby

require ENV["TM_BUNDLE_SUPPORT"] + "/markup"

Dir.chdir ENV['TM_PROJECT_DIRECTORY']

command = [ENV["TM_PYTHON"] || "python", "-u", "manage.py"] + ($* or ["runserver"]) +
  ["--pythonpath=/Users/matt/Projects/django-apps/current/"]

require ENV["TM_SUPPORT_PATH"] + "/lib/tm/executor"

TextMate::Executor.run(command) do |str, type|
  DjangoParser.parse(str,type)
end