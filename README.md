# alidayu_sms
阿里大鱼的短信发送api，暂时只支持 alibaba.aliqin.fc.sms.num.send 短信发送

# Gemfile
```ruby
gem 'alidayu_sms'
```

# start
##生成配置文件 config/alidayu_sms.yml

`rake alidayu_sms:create_default_config_file`

```ruby
defaults: &defaults
  alidayu:
    app_key: 23304964
    app_secret: "12b083a7c5e89ce3093067ddd65c4b5a"
    post_url: 'http://gw.api.taobao.com/router/rest'
    product: "阿里打鱼"
    sms_templates:
      - name: "sign_up"
        sms_free_sign_name: "注册验证" # 短信签名
        sms_template_code: "SMS_5019408" # 短信模板

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```

# 用法
## 登录短信示例
- 配置文件config/alidayu_sms.yml里的product即为 sms_param = sms_param[:product] = "阿里云", 则可不传这个字段

```ruby
# Alidayu::Sms.send_code_for_{name}( phone, sms_param={code: '1314520', product: '可选'}, extend="") {name}为配置文件sms_templates[:name]

Alidayu::Sms.send_code_for_sign_up("15921076830", {code: '1314520'}, '')
```

# 自定义模板

```ruby

options = {
  sms_param: "{'code':'1314520','product':'阿里云'}",
  phones: '152012211, 15921076830',
  extend: '', # 公共回传参数，在“消息返回”中会透传回该参数；举例：用户可以传入自己下级的会员ID，在消息返回时，该会员ID会包含在内，用户可以根据该会员ID识别是哪位会员使用了你的应用
  sms_free_sign_name: "注册验证", # 短信签名
  sms_template_code: "SMS_5045503" # 短信模板
}
result = AlidayuSmsSender.new.batchSendSms(options)

# 返回码参考 阿里大鱼 api文档
```