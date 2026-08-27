module Utils
  def get_doc(url)
    category_url = URI.escape(url)
    # Nokogiri::HTML(RestClient::Request.execute(:url => category_url, :timeout => 100, :method => :get, :verify_ssl => false))
    begin
      response = RestClient.get(category_url)
    rescue SocketError => e
      Rails.logger.error "Network/DNS Error: #{e.message}"
        # Handle the outage (e.g., return cached data, notify admin, or retry)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "API returned an HTTP error: #{e.response.code}"
    rescue StandardError => e
      Rails.logger.error "Something else went wrong: #{e.message}"
    end
    Nokogiri::HTML(response)
  end
end
