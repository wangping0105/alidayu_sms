$:.unshift File.expand_path('../../lib', __FILE__)

require 'pp'
require "active_support/all"

require "alidayu_sms/version"
require "alidayu_sms/alidayu"

require 'erb' unless defined? ERB
require 'yaml' unless defined? YMAL

# 连接配置文件
def load_config
  if defined? ::Rails
    @sms_config ||= HashWithIndifferentAccess.new(
      YAML.load(ERB::new(File.read("#{::Rails.root}/config/alidayu_sms.yml")).result)[::Rails.env] || {}
    )
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

    # 基础类实例
    self.source = AlidayuSms::Alidayu.new(options)

    # 动态方法
    # 生成配置文件配置的对应的发送各种类型短信的方法
    class_eval do
      load_config[:alidayu][:sms_templates].each do |sms_template|
        define_method("send_code_for_#{sms_template[:name]}") do |phone, _sms_param = {}, extend = ""|
          _sms_param[:product] ||= load_config[:alidayu][:product]

          options = {
            sms_param: _sms_param.to_json,
            phones: phone, # 手机号码, 可以传入多个哦,用 "," 分格
            extend: extend, # 公共回传参数，在“消息返回”中会透传回该参数；举例：用户可以传入自己下级的会员ID，在消息返回时，该会员ID会包含在内，用户可以根据该会员ID识别是哪位会员使用了你的应用
            sms_free_sign_name: sms_template[:sms_free_sign_name], # 短信签名
            sms_template_code: sms_template[:sms_template_code] # 短信模板
          }
          AlidayuSmsSender.new.batchSendSms(options)
        end
      end
    end
  end

  # 发送短信的基本方法, 不走配置文件
  # 只需要传入相应的参数 sms_param phones extend sms_free_sign_name sms_template_code 即可
  def batchSendSms(options = {})
    options = HashWithIndifferentAccess.new(options)
    arr = %w(sms_param phones extend sms_free_sign_name sms_template_code)
    attr, flag = [], false
    arr.each do |a|
      flag = true unless options[a]
      attr << options[a]
    end

    check_params(flag, options)

    source.standard_send_msg(attr)
  end

  private
  # 自定义参数检查
  def check_params(flag, options)
    raise "阿里大鱼自定义参数不全！\n你传入的: #{options.map{|k,v| k.to_sym}}\n需要传入: [:code :product :phones :extend :sms_free_sign_name :sms_template_code]"  if flag
  end

  # 系统参数检查
  def check_system_params(options)
    arr = %w(app_key app_secret post_url)
    attr, flag = [], false
    arr.each do |a|
      flag = true unless options[a]
      attr << options[a]
    end
    raise "阿里大鱼系统参数不全！\n你传入的: #{options.map{|k,v| k.to_sym}}\n需要传入: [:app_key, :app_secret, :post_url]\n请配置 config/alidayu_sms.yml "  if flag
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
