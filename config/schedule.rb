every 1.day, :at => '02:00' do
  runner "DpoUpdateJob.perform_later"
end

every 1.day, :at => '04:00' do
  runner "ImportInsalesXmlJob.perform_later"
end

every 1.day, :at => '04:30' do
  runner "CreateCsvPriceJob.perform_later"
end
every 1.day, :at => '05:00' do
  runner "CreateCsvQuantityJob.perform_later"
end