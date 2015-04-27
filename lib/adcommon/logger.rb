require 'fileutils'
require 'logger'

module ADC
  class Logger
    def initialize(config)
      validate! config
      @dir = File.expand_path(config[:dir])
      @env = config[:env] || DEFAULT_CONFIG[:env]
      @level = config[:level] || DEFAULT_CONFIG[:level]
      @file_count = config[:file_count] || DEFAULT_CONFIG[:file_count]
      @file_size = config[:file_size] || DEFAULT_CONFIG[:file_size]
      @file = File.expand_path("#{@env}.log", @dir)      
    end

    DEFAULT_CONFIG = {
      env: 'development',
      level: 'info',
      file_count: 10,
      file_size: 4096000
    }    

    VALID_ENV = %w(test production)
    VALID_ENV << DEFAULT_CONFIG[:env]

    VALID_LEVELS = %w(error warn info debug)
    VALID_LEVELS.each do |level|
      define_method level do |message, level|
        log(message, level)
      end
    end

    attr_reader :dir, :env, :file, :level, :file_count, :file_size

    private

    def validate!(config)
      unless config[:dir]
        raise_error "Logger dir should not be empty"
      end

      env = config[:env]
      if env && !(VALID_ENV.include? env)
        raise_error "Logger env should be in #{VALID_ENV}"
      end

      level = config[:level]
      if level && !(VALID_LEVELS.include? level)
        raise_error "Logger level should be in #{VALID_LEVELS}"
      end

      file_count = config[:file_count]
      if file_count && !(file_count.class == Fixnum)
        raise_error "Logger file_count should be an interger"
      end

      file_size = config[:file_size]
      if file_size && !(file_size.class == Fixnum)
        raise_error "Logger file_size should be an interger"
      end
    end

    def raise_error(message)
      raise ADC::Error::InvalidLoggerConfig.new message      
    end

    def log(message, level)      
      ::Logger.new(STDOUT).send(level, message) if @env == DEFAULT_CONFIG[:env]
      FileUtils.mkdir_p @dir unless File.exist? @dir
      File.open(@file, File::WRONLY | File::APPEND | File::CREAT) do |f|
        ::Logger.new(f, 10, 4096000).send(level, message)
      end
    end
  end
end