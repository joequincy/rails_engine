require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it {is_expected.to belong_to :merchant}
    it {is_expected.to have_many :invoice_items}
  end
end
