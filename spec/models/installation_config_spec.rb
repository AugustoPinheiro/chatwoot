# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InstallationConfig do
  it { is_expected.to validate_presence_of(:name) }

  describe 'INSTALLATION_IDENTIFIER validation' do
    context 'when value is a valid UUID' do
      it 'accepts lowercase hex UUIDs' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: 'a1b2c3d4-e5f6-4789-abcd-ef0123456789')
        expect(config).to be_valid
      end

      it 'accepts uppercase hex UUIDs' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: 'A1B2C3D4-E5F6-4789-ABCD-EF0123456789')
        expect(config).to be_valid
      end

      it 'accepts mixed case hex UUIDs' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: 'a1B2c3D4-e5F6-4789-AbCd-Ef0123456789')
        expect(config).to be_valid
      end

      it 'accepts SecureRandom.uuid generated UUIDs' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: SecureRandom.uuid)
        expect(config).to be_valid
      end
    end

    context 'when value is an invalid UUID' do
      it 'rejects UUIDs with non-hex characters like t' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: 'e04t63ee-5gg8-4b94-8914-ed8137a7d938')
        expect(config).not_to be_valid
        expect(config.errors[:value]).to include('must be a valid UUID format')
      end

      it 'rejects UUIDs with non-hex characters like g' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: '12345678-1234-1234-1234-12345678901g')
        expect(config).not_to be_valid
        expect(config.errors[:value]).to include('must be a valid UUID format')
      end

      it 'rejects UUIDs with wrong format (missing dashes)' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: '12345678123412341234123456789012')
        expect(config).not_to be_valid
        expect(config.errors[:value]).to include('must be a valid UUID format')
      end

      it 'rejects UUIDs with wrong segment lengths' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: '123-1234-1234-1234-123456789012')
        expect(config).not_to be_valid
        expect(config.errors[:value]).to include('must be a valid UUID format')
      end

      it 'rejects completely invalid strings' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: 'not-a-uuid')
        expect(config).not_to be_valid
        expect(config.errors[:value]).to include('must be a valid UUID format')
      end
    end

    context 'when value is blank' do
      it 'allows blank value (will be generated later)' do
        config = described_class.new(name: 'INSTALLATION_IDENTIFIER', value: nil)
        expect(config).to be_valid
      end
    end

    context 'when name is not INSTALLATION_IDENTIFIER' do
      it 'does not validate UUID format for other configs' do
        config = described_class.new(name: 'OTHER_CONFIG', value: 'not-a-uuid')
        expect(config).to be_valid
      end
    end
  end
end
