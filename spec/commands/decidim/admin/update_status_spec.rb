# frozen_string_literal: true

require "spec_helper"

module Decidim::Admin
  describe UpdateStatus do
    subject { described_class.new(status, form) }

    let(:organization) { create :organization }
    let(:user) { create :user, :admin, :confirmed, organization: organization }
    let(:status) { create :status, organization: organization }
    let(:name) { Decidim::Faker::Localized.literal("New name") }

    let(:form) do
      double(
        invalid?: invalid,
        current_user: user,
        name: name
      )
    end
    let(:invalid) { false }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the form is valid" do
      before do
        subject.call
        status.reload
      end

      it "updates the name of the status" do
        expect(translated(status.name)).to eq("New name")
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:update!)
          .with(status, user, hash_including(:name))
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
