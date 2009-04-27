#! /usr/bin/env ruby

Dir.chdir ENV['TM_PROJECT_DIRECTORY']

command = [ENV["TM_PYTHON"] || "python", "-u", "manage.py"] + ($* or "validate")

require ENV["TM_SUPPORT_PATH"] + "/lib/tm/executor"
require ENV["TM_BUNDLE_SUPPORT"] + "/find_file"

TextMate::Executor.run(command, :verb => "Validating") do |str, type|
  if str =~ /^(.*)\.(.*):\s\"(.*)\":(.*)/
    appname, model_name, attribute, message = $1, $2, $3, $4
    filename, line_number, column = FindModel.find(ENV['TM_PROJECT_DIRECTORY'], appname, model_name, attribute)
    file_link = "<a class=\"near\" href=\"txmt://open?line=#{line_number}&column=#{column}&file=#{filename}\">#{appname}.#{model_name}</a>"
    str = "#{file_link}: \"#{attribute}\": #{message}"
  end
  "<div class=\"#{type}\">#{str}</div>"
end