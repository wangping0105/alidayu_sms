require 'net/http'

module AlidayuSms
  class Alidayu
    attr_accessor :app_key, :app_secret, :post_url
    
    def initialize(options = {})
      self.app_key = options['app_key']
      self.app_secret = options['app_secret']
      self.post_url = options['post_url']
    end
    
    def standard_send_msg(arg = [])
      code, product, _phones, _extend, _sms_free_sign_name, _sms_template_code = arg

      _sms_param = "{'code':'#{code}','product':'#{product}'}"
      _timestamp = Time.now.strftime("%F %T")
      options = {
        app_key: self.app_key,
        format: 'json',
        method: 'alibaba.aliqin.fc.sms.num.send',
        partner_id: 'apidoc',
        sign_method: 'md5',
        timestamp: _timestamp,
        v: '2.0',
        extend: _extend,
        rec_num: _phones,
        sms_free_sign_name: _sms_free_sign_name,
        sms_param: _sms_param,
        sms_template_code: _sms_template_code,
        sms_type: 'normal'
      }

      options = sort_options(options)
      puts "options: #{options}"

      md5_str = 加密(options)
      response = post(self.post_url, options.merge(sign: md5_str))
      puts "phones: #{_phones}, #{_sms_param}, and respone: #{response}"
      response
    end

    private
    def sort_options(**arg)
      arg.sort_by{|k,v| k}.to_h
    end

    def 加密(**arg)
      _arg = arg.map{|k,v| "#{k}#{v}"}
      md5("#{self.app_secret}#{_arg.join("")}#{self.app_secret}").upcase
    end

    def md5(arg)
      Digest::MD5.hexdigest(arg)
    end

    def post(uri, options)
      response = ""
      url = URI.parse(uri)
      Net::HTTP.start(url.host, url.port) do |http|
        req = Net::HTTP::Post.new(url.path)
        req.set_form_data(options)
        response = http.request(req).body
      end
      JSON(response)
    end
  end
end


