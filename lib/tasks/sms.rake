namespace :sms do
  task :create_default_config_file do
    unless File.exist?("#{::Rails.root}/config/sms.yml")
      FileUtils.cp(File.expand_path("../../templates/sms.yml", __FILE__), "#{::Rails.root}/config/sms.yml")
    end
  end
end