$:.unshift File.expand_path('../../lib', __FILE__)

require 'pp'
require "active_support/all"

require "alidayu_sms/version"
require "alidayu_sms/alidayu"

require 'yaml' unless defined? YMAL

def load_config
  if defined? ::Rails
    @sms_config ||= HashWithIndifferentAccess.new(YAML.load_file("#{::Rails.root}/config/alidayu_sms.yml")[::Rails.env] || {})
  else
    {}
  end
end

class AlidayuSmsSender
  attr_accessor :source, :template_code

  def initialize(options = {})
    if load_config.present? && load_config[:alidayu].present?
      options = load_config[:alidayu].merge(options)
    end
    
    options = HashWithIndifferentAccess.new(options)
    @source = AlidayuSms::Alidayu.new(options)
  end

  # 发送短信
  def batchSendSms(options = {})
    arr = %w(code product phones extend sms_free_sign_name sms_template_code)
    arr.each do |a|
      unless options[a.to_sym]
        puts "参数不全！"  
      end
    end
    
    @source.standard_send_msg(arr.map{|a| options[a.to_sym]})
  end

end

if defined? ::Rails
  module AlidayuSms
    module Rails
      class Railtie < ::Rails::Railtie
        rake_tasks do
          load "tasks/alidayu_sms.rake"
        end
      end
    end
  end
end
