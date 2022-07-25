class ApiInsalesUpdateJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_update", status: "start", message: "Update API Insales"}
    Services::ApiInsalesUpdate.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_update", status: "finish", message: "Update API Insales"}
  end
end
