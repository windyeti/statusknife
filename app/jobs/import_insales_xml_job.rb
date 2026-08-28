class ImportInsalesXmlJob < ApplicationJob
  queue_as :default

  def perform
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "import_insales_xml", status: "start", message: "Импорт из Insales"}
    Services::ImportInsalesXml.new.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "import_insales_xml", status: "finish", message: "Импорт из Insales"}
  end
end
