class ZucpTest < Minitest::Test

  describe 'Sms::Zucp test' do

    before do
      @options = {source: "zucp", phone: "13262902619", content: Time.now.to_i.to_s, sn: "SDK-WSS-010-05925", pwd: "123456", suffix: '[test]'}
    end

    it 'SmsSender singleSend' do
      obj = SmsSender.new(@options)
      assert_instance_of Sms::Zucp, obj.source

      result = obj.singleSend(@options[:phone])
      assert result.to_i > 0
    end

    it 'SmsSender batchSend' do
      obj = SmsSender.new(@options)
      assert_instance_of Sms::Zucp, obj.source

      result = obj.batchSend(@options[:phone])
      assert result.to_i > 0
    end

    it 'Sms::Zucp singleSend' do
      obj = Sms::Zucp.new(@options)
      assert obj.sn.present?
      assert obj.pwd.present?

      result = obj.singleSend(@options[:phone])
      assert result.to_i > 0
    end

    it 'Sms::Zucp batchSend' do
      obj = Sms::Zucp.new(@options)
      assert obj.sn.present?
      assert obj.pwd.present?

      result = obj.batchSend(@options[:phone].split)
      assert result.to_i > 0
    end

  end

end