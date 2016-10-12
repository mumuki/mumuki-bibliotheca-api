describe Bibliotheca::Schema::Field do
  let(:exercise) { Mumukit::Service::Document.new(bar: 4) }

  describe 'when reverse field specified' do
    let(:field) { Bibliotheca::Schema::Field.new(kind: :metadata, name: :foo, reverse: :bar) }

    it { expect(field.name).to eq :foo }
    it { expect(field.reverse_name).to eq :bar }
    it { expect(field.get_field_value(exercise)).to eq 4 }
  end

  describe 'when no reverse field specified' do
    let(:field) { Bibliotheca::Schema::Field.new(kind: :metadata, name: :bar) }

    it { expect(field.name).to eq :bar }
    it { expect(field.reverse_name).to eq :bar }
    it { expect(field.get_field_value(exercise)).to eq 4 }

  end
end
