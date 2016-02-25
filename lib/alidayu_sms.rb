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
    check_system_params(options)

    @source = AlidayuSms::Alidayu.new(options)
    class_eval do
      load_config[:alidayu][:sms_templates].each do |sms_template|
        define_method("send_code_for_#{sms_template[:name]}") do |code, phone, extend = ""|
          options = {
            code: code, # 模板的{code}字段
            phones: phone, # 手机号码
            product: load_config[:alidayu][:product], # 模板的{product}字段
            extend: extend, # 公共回传参数，在“消息返回”中会透传回该参数；举例：用户可以传入自己下级的会员ID，在消息返回时，该会员ID会包含在内，用户可以根据该会员ID识别是哪位会员使用了你的应用
            sms_free_sign_name: sms_template[:sms_free_sign_name], # 短信签名
            sms_template_code: sms_template[:sms_template_code] # 短信模板
          }
          AlidayuSmsSender.new.batchSendSms(options)
        end
      end
    end
  end

  # 发送短信
  def batchSendSms(options = {})
    options = HashWithIndifferentAccess.new(options)

    arr = %w(code product phones extend sms_free_sign_name sms_template_code)
    attr, flag = [], false
    arr.each do |a|
      flag = true unless options[a]
      attr << options[a]
    end

    check_params(flag, options)
    puts "阿里大鱼传入参数为：#{attr}"

    @source.standard_send_msg(attr)
  end

  private
  def check_params(flag, options)
    raise "阿里大鱼自定义参数不全！\n你传入的: #{options.map{|k,v| k.to_sym}}\n需要传入: [:code :product :phones :extend :sms_free_sign_name :sms_template_code]"  if flag
  end

  def check_system_params(options)
    arr = %w(app_key app_secret post_url)
    attr, flag = [], false
    arr.each do |a|
      flag = true unless options[a]
      attr << options[a]
    end
    raise "阿里大鱼系统参数不全！\n你传入的: #{options.map{|k,v| k.to_sym}}\n需要传入: [:app_key, :app_secret, :post_url]\n请配置 alidayu_sms.yml"  if flag
    puts "阿里大鱼系统参数检测完毕！"
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
