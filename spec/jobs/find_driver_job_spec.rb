require 'rails_helper'

RSpec.describe FindDriverJob, type: :job do
  before :each do
    @user = create(:user)
    @order = create(:order, user_id: @user.id)
  end

  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      FindDriverJob.perform_later(@order)
    }.to have_enqueued_job.with(@order)
  end

  it "is on the default queue priority" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      FindDriverJob.perform_later(@order)
    }.to have_enqueued_job.on_queue("default")
  end
end
