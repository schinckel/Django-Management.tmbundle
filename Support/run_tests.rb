#! /usr/bin/env ruby

require ENV["TM_BUNDLE_SUPPORT"] + "/markup"

command = [ENV["TM_PYTHON"] || "python", "-u", "#{ENV['TM_PROJECT_DIRECTORY']}/manage.py", "test", "--noinput"]

tests = []

File.open(ENV['TM_FILEPATH']) do |f|
  f.readlines.each do |line|
    if line =~ /class (.*)\(.*TestCase\):/
      test_case = $1
      app_name = ENV['TM_FILEPATH'].split(ENV['TM_PROJECT_DIRECTORY'])[1].split('/')[1]
      test_name = "#{app_name}.#{test_case}"
      command << test_name
      tests << "#{test_case}"
    end
  end
end

if tests == []
  ENV['TM_DISPLAYNAME'] = ENV['TM_PROJECT_DIRECTORY'].split('/')[-1] 
else
  ENV['TM_DISPLAYNAME'] = tests.join ", "
end

require ENV["TM_SUPPORT_PATH"] + "/lib/tm/executor"

ENV["PYTHONPATH"] = ENV["TM_BUNDLE_SUPPORT"] + (ENV.has_key?("PYTHONPATH") ? ":" + ENV["PYTHONPATH"] : "")

TextMate::Executor.run(command, :verb => "Testing") do |str, type|
  DjangoParser.parse(str,type)
end