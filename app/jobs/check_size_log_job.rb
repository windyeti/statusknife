class CheckSizeLogJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "check_size_log", status: "start", message: "Check Size Log"}
    Services::Util::CheckSizeLog.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "check_size_log", status: "finish", message: "Check Size Log"}
  end
end
