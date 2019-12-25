# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe LunchGame::Helpers do
  let(:helper) { LunchGame::Helpers }

  before do
    allow(helper).to receive(:origin_index_in_physical_direction).and_call_original
  end

  shared_examples_for 'a subject that raises a ForbiddenArgumentValue error' do
    it 'raises the adequate error' do
      expect { subject }.to raise_error(LunchGame::Errors::ForbiddenArgumentValueError)
    end
  end


  describe '#origin_index_in_physical_direction' do
    let(:subject) { helper.origin_index_in_physical_direction(origin_direction) }
    let(:origin_direction) { :foo }

    it_behaves_like 'a subject that raises a ForbiddenArgumentValue error'

    context 'with a valid direction' do
      let(:origin_direction) { :north }

      it { is_expected.to eq LunchGame::Helpers::PHYSICAL_DIRECTIONS.index(origin_direction) }
    end
  end

  # @let method_call
  # @let origin_direction
  shared_examples_for 'a method that checks its origin_direction argument' do
    it 'calls origin_index_in_physical_direction' do
      subject
      expect(helper).to have_received(:origin_index_in_physical_direction).with(origin_direction)
    end
  end

  describe '#opposite_direction' do
    let(:subject) { helper.opposite_direction(origin_direction)}
    let(:origin_direction) { :north }

    it_behaves_like 'a method that checks its origin_direction argument'
    it { is_expected.to eq :south }

    context 'with :south' do
      let(:origin_direction) { :south }
      it { is_expected.to eq :north }
    end

    context 'with :east' do
      let(:origin_direction) { :east }
      it { is_expected.to eq :west }
    end

    context 'with :west' do
      let(:origin_direction) { :west }
      it { is_expected.to eq :east }
    end
  end

  describe '#relative_directions' do
    let(:method_call) { helper.relative_directions(origin_direction: origin_direction, directions: directions)}
    let(:origin_direction) { :north }
    let(:directions) { %i[north south] }

    before do
      allow(helper).to receive(:origin_index_in_physical_direction).and_return(:origin_index)
      allow(helper).to receive(:relative_direction).and_return(:relative_direction_result)
    end

    it_behaves_like 'a method that checks its origin_direction argument' do
      let(:subject) { method_call }
    end

    it 'calls relative_direction on every direction and return the result as array' do
      aggregate_failures do
        expect(method_call.size).to eq directions.size
        method_call.each_with_index do |direction, index|
          expect(helper).to have_received(:relative_direction)
            .with(direction: directions[index], origin_direction_index: :origin_index)
          expect(direction).to eq(:relative_direction_result)
        end
      end
    end
  end

  describe '#relative_direction' do
    let(:subject) do
      helper.relative_direction(
        direction: direction,
        origin_direction_index: origin_direction_index,
      )
    end

    let(:direction) { :north }
    let(:origin_direction_index) { 0 } # index of north

    it { is_expected.to eq :backward }

    context 'with :south' do
      let(:direction) { :south }
      it { is_expected.to eq :forward }
    end

    context 'with :east' do
      let(:direction) { :east }
      it { is_expected.to eq :left }
    end

    context 'with :west' do
      let(:direction) { :west }
      it { is_expected.to eq :right }
    end

    context 'with an invalid direction' do
      let(:direction) { :de }
      it_behaves_like 'a subject that raises a ForbiddenArgumentValue error'
    end
  end

  describe '#relative_to_physical_direction' do
    let(:subject) do
      helper.relative_to_physical_direction(
        origin_direction: origin_direction,
        relative_direction: relative_direction,
      )
    end
    let(:origin_direction) { :north }
    let(:relative_direction) { :forward }

    it { is_expected.to eq :south }

    context 'going left' do
      let(:relative_direction) { :left }
      it { is_expected.to eq :east }
    end

    context 'going right' do
      let(:relative_direction) { :right }
      it { is_expected.to eq :west }
    end

    context 'going backward' do
      let(:relative_direction) { :backward }
      it { is_expected.to eq :north }
    end

    context 'with an invalid origin_direction' do
      let(:origin_direction) { :forward }
      it_behaves_like 'a subject that raises a ForbiddenArgumentValue error'
    end

    context 'with an invalid relative direction' do
      let(:relative_direction) { :north }
      it_behaves_like 'a subject that raises a ForbiddenArgumentValue error'
    end
  end
end
