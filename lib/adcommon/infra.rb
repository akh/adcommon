require 'fileutils'
require 'logger'

def info(message)
  Logger.new(STDOUT).info ">>>>> #{message}\n"
end

def run(command)
  info "Will run command #{command}"
  abort "Failed to run command => #{command}" unless system command
end

def clean_dir(dir)
  FileUtils.rm_rf dir if File.directory? dir
  FileUtils.mkdir_p dir
end

def require_dir(dir)
  Dir.foreach(dir) do |entry|
    absolute_path = File.join(dir, entry)
    next if (entry == "." || entry == "..")
    require absolute_path if (File.file?(absolute_path) && absolute_path.end_with?("rb"))
    require_dir(absolute_path) if File.directory?(absolute_path)
  end
end
