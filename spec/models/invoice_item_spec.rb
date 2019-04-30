require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it {is_expected.to belong_to :item}
    it {is_expected.to belong_to :invoice}
  end
end
