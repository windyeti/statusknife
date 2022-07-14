class CreateCsvPriceJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "create_csv_price", status: "start", message: "Создание Csv Price"}
    Services::CreateCsvPrice.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "create_csv_price", status: "finish", message: "Создание Csv Price"}
  end
end
