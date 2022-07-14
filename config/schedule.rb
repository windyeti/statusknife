every 1.day, :at => '02:00' do
  runner "DpoUpdateJob.perform_later"
end

every 1.day, :at => '03:00' do
  runner "ImportInsalesXmlJob.perform_later"
end

every 1.day, :at => '04:30' do
  runner "CreateCsvPriceJob.perform_later"
end
every 1.day, :at => '04:35' do
  runner "CreateCsvQuantityJob.perform_later"
end
