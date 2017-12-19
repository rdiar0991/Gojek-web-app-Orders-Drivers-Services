module RequestSpecHelper
  # Parse JSON response to Ruby Hash
  def json
    JSON.parse(response.body)
  end
end
