class ApiInsalesPriceJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_price", status: "start", message: "Update API Insales Price"}
    Services::ApiInsalesPrice.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "api_insales_price", status: "finish", message: "Update API Insales Price"}
  end
end
