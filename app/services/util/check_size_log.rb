class Services::Util::CheckSizeLog
  def call
    ["delayed_job.log", "production.log"].each do |file_name|
      path = File.join("/var/www/statusknife/shared/log", file_name)
      if File.exist?(path) && File.size(path) > 100000000
        File.open(path, 'w') {|file| file.truncate(0) }
      end
    end
  end
end
