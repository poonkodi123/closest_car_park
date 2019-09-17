require "spec_helper"

RSpec.describe CarPark, type: :model do
  context 'Search Nearest Car Park' do
    it "get nearest latitude and longitude " do
      result = CarPark.search(1.27236, 103.8977)
      expect(result).not_to eq(nil)

    end
  end
end
