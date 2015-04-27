require "test_helper"

class LoggerTest < Minitest::Test

  def setup
    @expected_dir = '~/tmp'
    @expected_env = 'production'
    @expected_file = File.expand_path("#{@expected_env}.log", @expected_dir)
    @expected_level = 'info'
    @expected_file_count = 10
    @expected_file_size = 4096000

    @config = {
      dir: @expected_dir,
      env: @expected_env,
      level: @expected_level,
      file_count: @expected_file_count,
      file_size: @expected_file_size
    }    
  end

  def test_respond_to_different_levels
    logger = ADC::Logger.new(@config)

    expected_levels = %w(error warn info debug)
    expected_levels.each do |level|
      assert_respond_to logger, level, "logger should respond to level #{level}"
    end
  end  

  def test_has_correct_config
    logger = ADC::Logger.new(@config)    
    assert_equal File.expand_path(@expected_dir), logger.dir 
    assert_equal @expected_env, logger.env
    assert_equal @expected_file, logger.file
  end

  def test_throw_error_if_dir_is_missing
    @config.delete(:dir)

    assert_raises(ADC::Error::InvalidLoggerConfig) {
      ADC::Logger.new(@config)
    }
  end

  def test_will_expand_path_to_absolute_path
    absolute_path = File.expand_path(@expected_dir)
    logger = ADC::Logger.new(@config)
    assert_equal absolute_path, logger.dir
  end

  def test_throw_error_if_env_is_incorrect
    @config.merge!(env: 'invalid')
    assert_raises(ADC::Error::InvalidLoggerConfig) {
      ADC::Logger.new(@config)
    }
  end

  def test_should_have_development_as_default_env
    @config.delete(:env)    
    logger = ADC::Logger.new(@config)
    assert_equal 'development', logger.env 
  end

  def test_throw_error_if_level_is_incorrect
    @config.merge!(level: 'invalid')
    assert_raises(ADC::Error::InvalidLoggerConfig) {
      ADC::Logger.new(@config)
    }
  end

  def test_should_have_info_as_default_level
    @config.delete(:level)    
    logger = ADC::Logger.new(@config)
    assert_equal 'info', logger.level 
  end

  def test_file_count_should_be_fixnum
    logger = ADC::Logger.new(@config)
    assert_instance_of(Fixnum, logger.file_count, "file_count should be integer")

    @config.merge!(file_count: 'invalid')
    assert_raises(ADC::Error::InvalidLoggerConfig) {
      ADC::Logger.new(@config)
    }    
  end

  def test_should_have_10_as_default_file_count
    @config.delete(:file_count)    
    logger = ADC::Logger.new(@config)
    assert_equal 10, logger.file_count
  end

  def test_should_have_4096000_as_default_file_size
    @config.delete(:file_size)    
    logger = ADC::Logger.new(@config)
    assert_equal 4096000, logger.file_size
  end

  def test_file_size_should_be_fixnum
    logger = ADC::Logger.new(@config)
    assert_instance_of(Fixnum, logger.file_size, "file_size should be integer")

    @config.merge!(file_size: 'invalid')
    assert_raises(ADC::Error::InvalidLoggerConfig) {
      ADC::Logger.new(@config)
    }    
  end

end