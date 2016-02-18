# alidayu_sms
阿里大鱼的短信发送api，暂时只支持 alibaba.aliqin.fc.sms.num.send 短信发送

# Gemfile add
gem 'alidayu_sms'

# start
##生成配置文件示例！(my :app_key and :app_secret, Valid to 2016.02.22)
rake alidayu_sms:create_default_config_file
```ruby
defaults: &defaults
  alidayu:
    app_key: 23304964
    app_secret: "12b083a7c5e89ce3093067ddd65c4b5a"
    post_url: 'http://gw.api.taobao.com/router/rest'

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```
## hello world!
```ruby
options = {
  code: 1314520, # 模板的{code}字段
  phones: "1520122011,1591251515", # 手机号码
  product: "阿里云", # 模板的{product}字段
  extend: '', # 公共回传参数，在“消息返回”中会透传回该参数；举例：用户可以传入自己下级的会员ID，在消息返回时，该会员ID会包含在内，用户可以根据该会员ID识别是哪位会员使用了你的应用
  sms_free_sign_name: "注册验证", # 短信签名
  sms_template_code: "SMS_5045503" # 短信模板
}
result = AlidayuSmsSender.new.batchSendSms(options)

# 返回码参考 阿里大鱼 api文档
```


