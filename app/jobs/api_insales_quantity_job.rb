class ApiInsalesQuantityJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_quantity", status: "start", message: "Update API Insales Quantity"}
    Services::ApiInsalesQuantity.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_quantity", status: "finish", message: "Update API Insales Quantity"}
  end
end
