module Utils
  def get_doc(url)
    category_url = URI.escape(url)
    begin
      res = Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
    rescue SocketError => e
      File.open("#{Rails.public_path}/errors_parse.txt", 'a') do |file|
        file.write "Network/DNS Error: #{e.message}\n#{res}"
      end
      Rails.logger.error "Network/DNS Error: #{e.message}"
        # Handle the outage (e.g., return cached data, notify admin, or retry)
    rescue RestClient::ExceptionWithResponse => e
      File.open("#{Rails.public_path}/errors_parse.txt", 'a') do |file|
        file.write "API returned an HTTP error: #{e.response.code}\n"
      end
      Rails.logger.error "API returned an HTTP error: #{e.response.code}"
    rescue StandardError => e
      File.open("#{Rails.public_path}/errors_parse.txt", 'a') do |file|
        file.write "Something else went wrong: #{e.message}\n"
      end
      Rails.logger.error "Something else went wrong: #{e.message}"
    end
    # response = RestClient.get(category_url)
    # begin
    # rescue SocketError => e
    #   Rails.logger.error "Network/DNS Error: #{e.message}"
    #     # Handle the outage (e.g., return cached data, notify admin, or retry)
    # rescue RestClient::ExceptionWithResponse => e
    #   Rails.logger.error "API returned an HTTP error: #{e.response.code}"
    # rescue StandardError => e
    #   Rails.logger.error "Something else went wrong: #{e.message}"
    # end
    # Nokogiri::HTML(response)
  end
end
