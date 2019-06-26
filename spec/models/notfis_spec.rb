require 'rails_helper'

RSpec.describe Notfis, type: :model do
  let(:notfis) { FactoryBot.create(:notfis) }

  it 'is valid if all fields have value' do
    expect { notfis }.to change { Notfis.count }.by(1)
  end
end
