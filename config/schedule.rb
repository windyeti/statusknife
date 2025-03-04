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

# -------------------
every 1.day, :at => '09:00' do
  runner "DpoUpdateJob.perform_later"
end

every 1.day, :at => '10:00' do
  runner "ImportInsalesXmlJob.perform_later"
end

every 1.day, :at => '11:00' do
  runner "ApiInsalesQuantityJob.perform_later"
end

every 1.day, :at => '12:00' do
  runner "ApiInsalesPriceJob.perform_later"
end

# ------------------- Check Size Log
#
every 1.day, :at => '13:00' do
  runner "CheckSizeLogJob.perform_later"
end

# -------------------
every 1.day, :at => '16:00' do
  runner "DpoUpdateJob.perform_later"
end

every 1.day, :at => '17:00' do
  runner "ImportInsalesXmlJob.perform_later"
end

every 1.day, :at => '18:00' do
  runner "ApiInsalesQuantityJob.perform_later"
end

every 1.day, :at => '19:00' do
  runner "ApiInsalesPriceJob.perform_later"
end
