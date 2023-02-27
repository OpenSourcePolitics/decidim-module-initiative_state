# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Status do
    subject(:status) { build(:status, organization: organization) }

    let(:organization) { create(:organization) }

    it { is_expected.to be_valid }
    it { is_expected.to be_versioned }

    context "with two areas with the same name and organization" do
      let!(:existing_status) { create(:status, name: status.name, organization: organization) }

      it { is_expected.to be_invalid }
    end

    context "with two areas with the same name in different organizations" do
      let!(:existing_status) { create(:status, name: status.name) }

      it { is_expected.to be_valid }
    end

    context "without name" do
      before do
        status.name = {}
      end

      it { is_expected.to be_invalid }
    end

    context "without organization" do
      before do
        status.organization = nil
      end

      it { is_expected.to be_invalid }
    end
  end
end
