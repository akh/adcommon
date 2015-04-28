require "test_helper"
require 'uri'

class UrlBuilderTest < Minitest::Test

  def setup
    @base_url = 'http://mp.weixin.qq.com/s'
    @param_key = "encoded_content"
    @original_content = 'MjAzNzMzNTkyMQ=='
    @encoded_content = 'MjAzNzMzNTkyMQ%3D%3D'    
    @fragment = 'fragment'
  end

  def test_build_url_with_multiple_query_params
  	expected_url = 'http://mp.weixin.qq.com/s?mid=205371163&idx=1&sn=6cbdf251f994fbe1a8de8bab95938e0c'

    url_builder = ADC::UrlBuilder.new

		url = url_builder
							 .add_base(@base_url)
		           .add_params(mid: '205371163', idx: '1', sn: '6cbdf251f994fbe1a8de8bab95938e0c')
		           .build

    assert_equal expected_url, url
  end  

  def test_build_url_with_encoded_content
  	expected_url = "#{@base_url}?#{@param_key}=#{@encoded_content}"
    url_builder = ADC::UrlBuilder.new
		url = url_builder
							 .add_base(@base_url)
		           .add_params(@param_key => @original_content)
		           .build
    assert_equal expected_url, url
  end

  def test_build_url_with_fragment
  	expected_url = "#{@base_url}?#{@param_key}=#{@encoded_content}\##{@fragment}"
    url_builder = ADC::UrlBuilder.new
		url = url_builder
							 .add_base(@base_url)
		           .add_params(@param_key => @original_content)
		           .add_fragment(@fragment)
		           .build
    assert_equal expected_url, url
  end

  def test_build_from_config
    param_1_name  = 'scene'
    param_1_value = '10000005'
    param_2_name  = 'size'
    param_2_value = '102'

    scheme = 'http'
    host = 'mp.weixin.qq.com'
    path = '/s'

    base_url = "#{scheme}://#{host}#{path}"

    config = { 
        :base_url => base_url, 
        :query_params=>
        [
          {:name=> param_1_name, :value=> param_1_value}, 
          {:name=> param_2_name, :value=> param_2_value}
        ],
        :fragment => @fragment
    }

    extra_param_name = 'extra'
    extra_param_value = 'extra_value'
    extra_param = { extra_param_name => extra_param_value }

    url_builder = ADC::UrlBuilder.new
    result = URI(url_builder.build_from_config(config, extra_param))

    assert_equal scheme, result.scheme
    assert_equal host, result.host
    assert_equal path, result.path
    assert_equal @fragment, result.fragment

    assert result.to_s.include?("#{param_1_name}=#{param_1_value}")
    assert result.to_s.include?("#{param_2_name}=#{param_2_value}")
    assert result.to_s.include?("#{extra_param_name}=#{extra_param_value}")
  end
end