require 'rails_helper'

RSpec.describe 'JsonWebToken' do
      it 'returns jwt token' do
        expect(JsonWebTokenRepository.jwt_encode(id_user: 1)).to be_instance_of(String)

      end

      it 'decodes jwt token to hash' do
        encoded = JsonWebTokenRepository.jwt_encode(id_user: 1)
        decoded = JsonWebTokenRepository.jwt_decode(encoded)

        expect(decoded[:id_user]).to eq(1)
      end
  end