require "uri"

module ADC
  class UrlBuilder
    def build_from_config(config, extra_params = nil)
      query_params = extra_params || {}
      config[:query_params].each { |item| query_params[item[:name]] = item[:value] }
      add_fragment(config[:fragment]) if config[:fragment]
      add_base(config[:base_url]).add_params(query_params).build      
    end

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
        path: "#{@base_url.path}#{@extra_path}", query: query_str, fragment: @fragment).to_s
    end

    def add_path(path)
      @extra_path = path
      self
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