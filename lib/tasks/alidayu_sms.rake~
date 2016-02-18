namespace :alidayu_sms do
  task :create_default_config_file do
    unless File.exist?("#{::Rails.root}/config/alidayu_sms.yml")
      FileUtils.cp(File.expand_path("../../templates/alidayu_sms.yml", __FILE__), "#{::Rails.root}/config/alidayu_sms.yml")
    end
  end
end
