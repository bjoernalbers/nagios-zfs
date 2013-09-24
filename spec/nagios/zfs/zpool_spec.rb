require 'spec_helper'

module Nagios
  module ZFS
    describe Zpool do
      let(:zpool) { Zpool.new('tank') }

      before do
        Zpool.any_instance.stub(:`).and_return('')
      end

      describe '#capacity' do
        it 'returns the capacity' do
          zpool.should_receive(:query).and_return("tank\t87%\n")
          expect(zpool.capacity).to eq(87)
        end
      end

      describe '#query' do
        it 'runs and caches the zpool query for the given pool' do
          zpool.should_receive(:`).with('zpool list -H -o name,cap tank').
            once.and_return('chunky bacon')
          2.times { expect(zpool.send(:query)).to eq('chunky bacon') }
        end
      end
    end
  end
end
