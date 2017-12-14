require 'rails_helper'

RSpec.describe Driver, type: :model do
  # valid factory
  it "has a valid factory" do
    expect(build(:driver)).to be_valid
  end

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:name).is_at_most(51) }
  it { should validate_length_of(:email).is_at_most(255) }
  it { should have_secure_password }
  it { should validate_length_of(:password).is_at_least(8) }
  it { should validate_presence_of(:phone) }
  it { should validate_uniqueness_of(:phone) }
  it { should validate_numericality_of(:phone) }
  it { should validate_length_of(:phone).is_at_least(11) }
  it { should validate_length_of(:phone).is_at_most(13) }
  it { should validate_presence_of(:go_service) }
  it { should validate_presence_of(:gopay_balance).on(:update) }
  it { should validate_numericality_of(:gopay_balance).is_greater_than_or_equal_to(0.0).on(:update) }
  it { should validate_presence_of(:go_service) }
  it { should validate_presence_of(:current_location).on(:update) }
  it { should validate_presence_of(:bid_status).on(:update) }
  it { should validate_presence_of(:current_coord).on(:update) }

  # Association tests
  it { should have_many(:orders).dependent(:destroy) }

  # validation of email format
  describe "Email format Validation" do
    it "is valid email format" do
      driver = build(:driver, email: "marzan@gmail.com")
      expect(driver).to be_valid
    end
    it "is invalid email format" do
      driver = build(:driver, email: "marzan@gmail,com")
      expect(driver).not_to be_valid
    end
    it "downcases an email before saving" do
      driver = create(:driver, email: "MarZan@gMail.CoM")
      expect(driver.email).to match(/marzan@gmail.com/)
    end
  end
end
