every 1.day, :at => '02:00' do
  runner "DpoUpdateJob.perform_later"
end

every 1.day, :at => '03:00' do
  runner "ImportInsalesXmlJob.perform_later"
end

every 1.day, :at => '04:00' do
  runner "ApiInsalesQuantityJob.perform_later"
end

every 1.day, :at => '05:00' do
  runner "ApiInsalesPriceJob.perform_later"
end
