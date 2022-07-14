class DpoUpdateJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "dpo", process: "update_distributor", status: "start", message: "Обновление товаров поставщика Dpo"}
    Services::Vendor::DpoUpdate.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "dpo", process: "update_distributor", status: "finish", message: "Обновление товаров поставщика Dpo"}
  end
end
