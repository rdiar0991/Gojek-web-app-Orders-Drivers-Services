require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:driver) }
  it { should validate_presence_of(:origin) }
  it { should validate_presence_of(:destination) }
  it { should validate_presence_of(:payment_type) }
  it { should validate_numericality_of(:distance) }
  it { should validate_numericality_of(:price) }

  it "has valid factory" do
    # before { @driver = create(:dri) }
    expect(build(:order)).to be_valid
  end
end
