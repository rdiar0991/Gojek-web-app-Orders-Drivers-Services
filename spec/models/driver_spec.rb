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
  it { should validate_presence_of(:bid_status).on(:update) }


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

  describe "Current location and current coordinates validations ON UPDATE" do
    before :each do
      @driver = create(:driver)
    end
    context "with bid_status = 'Offline'" do
      it "is valid current coord" do
        @driver.bid_status = "Offline"
        @driver.current_location = nil
        @driver.current_coord = nil
        @driver.save
        expect(@driver).to be_valid
      end
    end

    context "with bid_status = 'Online'" do
      it "is valid current_coord" do
        @driver.bid_status = "Online"
        @driver.current_location = "Sarinah, Jakarta"
        @driver.save
        expect(@driver).to be_valid
      end

      it "is invalid current coord" do
        @driver.bid_status = "Online"
        @driver.save
        expect(@driver).not_to be_valid
      end
    end
    context "current_coord is depend on current_location" do
      it "is invalid current_coord" do
        @driver.bid_status = "Online"
        @driver.current_coord = "-6.1877157, 106.8238402"
        @driver.current_location = nil
        @driver.save
        expect(@driver).not_to be_valid
      end
    end
  end
end
