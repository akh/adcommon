require "uri"

module ADC
  class UrlBuilder
    def add_base(base_url)
      @base_url = URI::parse(base_url)
      self
    end

    def add_params(params)
      params.each_pair { |key, value| add_param key, value }
      self
    end

    def build
      @params ||= {}
      query_str = URI::encode_www_form(@params)
      URI::HTTP.build(host: @base_url.host, port: @base_url.port, 
        path: @base_url.path, query: query_str, fragment: @fragment).to_s
    end

    def add_fragment(fragment)
      @fragment = fragment
      self
    end    

    private

    def add_param(key, value)
      @params ||= {}
      @params[key] = value
      self
    end

  end
end