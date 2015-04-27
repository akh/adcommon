module NAME
  VERSION = '0.0.1'
end


libs = %w(uri)
libs.each	{ |lib| require lib }

files = %w(infra url_builder)
adcommon_dir = File.expand_path('adcommon', __dir__)
files.each { |file| require File.expand_path(file, adcommon_dir)}