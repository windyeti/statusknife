class ApiInsalesQuantityJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_quantity", status: "start", message: "Quantity API Insales"}
    Services::ApiInsalesQuantity.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_quantity", status: "finish", message: "Quantity API Insales"}
  end
end
