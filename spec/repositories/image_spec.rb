require 'rails_helper'

RSpec.describe 'Image' do
      it 'returns type of string as text if input is string' do
        str = 'lorem ipsum dolor sit amet'
        expect(ImageRepository.input_type(str)).to eq('text')

      end
  end