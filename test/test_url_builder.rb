require "test_helper"

class UrlBuilderTest < Minitest::Test
  def test_build_url_with_multiple_query_params
  	expected_url = 'http://mp.weixin.qq.com/s?mid=205371163&idx=1&sn=6cbdf251f994fbe1a8de8bab95938e0c'

    url_builder = ADC::UrlBuilder.new

		url = url_builder
							 .add_base('http://mp.weixin.qq.com/s')
		           .add_params(mid: '205371163', idx: '1', sn: '6cbdf251f994fbe1a8de8bab95938e0c')
		           .build

    assert_equal expected_url, url
  end  

  def test_build_url_with_encoded_content
  	base_url = 'http://mp.weixin.qq.com/s'
  	param_key = "encoded_content"
  	original_content = 'MjAzNzMzNTkyMQ=='
  	encoded_content = 'MjAzNzMzNTkyMQ%3D%3D'
  	expected_url = "#{base_url}?#{param_key}=#{encoded_content}"

    url_builder = ADC::UrlBuilder.new

		url = url_builder
							 .add_base(base_url)
		           .add_params(param_key => original_content)
		           .build

    assert_equal expected_url, url
  end

  def test_build_url_with_fragment
  	base_url = 'http://mp.weixin.qq.com/s'
  	param_key = "encoded_content"
  	original_content = 'MjAzNzMzNTkyMQ=='
  	encoded_content = 'MjAzNzMzNTkyMQ%3D%3D'
  	fragment = 'fragment'
  	expected_url = "#{base_url}?#{param_key}=#{encoded_content}\##{fragment}"

    url_builder = ADC::UrlBuilder.new

		url = url_builder
							 .add_base(base_url)
		           .add_params(param_key => original_content)
		           .add_fragment(fragment)
		           .build

    assert_equal expected_url, url
  end
end