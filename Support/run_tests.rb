#! /usr/bin/env ruby

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
  if type == :err
    if str =~ /\A[\.EF]*\Z/
      str.gsub!(/(\.)/, "<span class=\"test ok\">\\1</span>")
      str.gsub!(/(E|F)/, "<span class=\"test fail\">\\1</span>")
      str + "<br/>\n"
    elsif str =~ /\A(FAILED.*)\Z/
      "<div class=\"test fail\">#{htmlize $1}</div>\n"
    elsif str =~ /\A(OK.*)\Z/
      "<div class=\"test ok\">#{htmlize $1}</div>\n"
    elsif str =~ /^(\s+)File "(.+)", line (\d+), in (.*)/
      indent = $1
      file   = $2
      line   = $3
      method = $4
      indent += " " if file.sub!(/^\"(.*)\"/,"\1")
      url = "&url=file://" + e_url(file)
      display_name = file.split('/').last 
      "#{htmlize(indent)}<a class=\"near\" href=\"txmt://open?line=#{line + url}\">" +
        (method ? "method #{method}" : "<em>at top level</em>") +
        "</a> in <strong>#{display_name}</strong> at line #{line}<br/>\n"
    end
  end
end