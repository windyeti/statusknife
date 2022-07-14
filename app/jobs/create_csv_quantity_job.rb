class CreateCsvQuantityJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "create_csv_quantity", status: "start", message: "Создание Csv Quantity"}
    Services::CreateCsvQuantity.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "create_csv_quantity", status: "finish", message: "Создание Csv Quantity"}
  end
end
