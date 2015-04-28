module NAME
  VERSION = '0.0.2.3'
end


libs = %w(uri)
libs.each	{ |lib| require lib }

adcommon_dir = File.expand_path('adcommon', __dir__)
require File.expand_path('infra', adcommon_dir)
require_dir adcommon_dir