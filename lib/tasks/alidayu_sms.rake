namespace :alidayu_sms do
  task :create_default_config_file do
    unless File.exist?("#{::Rails.root}/config/alidayu_sms.yml")
      FileUtils.cp(File.expand_path("../../templates/alidayu_sms.yml", __FILE__), "#{::Rails.root}/config/alidayu_sms.yml")
    end
    unless File.exist?("#{::Rails.root}/config/initializers/alidayu.rb")
      FileUtils.cp(File.expand_path("../../templates/alidayu.rb", __FILE__), "#{::Rails.root}/config/initializers/alidayu.rb")
    end
    puts '阿里大鱼初始化成功'
  end
end
