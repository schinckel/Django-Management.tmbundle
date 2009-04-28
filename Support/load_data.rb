#! /usr/bin/env ruby

require ENV["TM_BUNDLE_SUPPORT"] + "/markup"

Dir.chdir ENV['TM_PROJECT_DIRECTORY']

command = ["python", "-u", "manage.py", "loaddata"]

require ENV["TM_SUPPORT_PATH"] + "/lib/tm/executor"

command << ENV["TM_FILEPATH"] unless ENV["TM_SELECTED_FILES"]

ENV["TM_SELECTED_FILES"].split(' ').each do |file|
  file = file.gsub("'", "")
  if File.directory? file
    Dir.glob(file + '/*').each do |f|
      command << f unless File.directory? f
    end
  else
    command << file
  end
end

TextMate::Executor.run(command) do |str, type|
  DjangoParser.parse(str,type)
end