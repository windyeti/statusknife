class Services::Util::CheckSizeLog
  def initialize

  end

  def call
    ["delayed_job.log", "production.log"].each do |file_name|
      path = File.join("/var/www/statusknife/shared/log", file_name)
      File.rm(path) if File.exist?(path) && File.size(path) > 1000000
    end
  end
end
