require 'spec_helper'

module Nagios
  module ZFS
    describe Zpool do
      let(:zpool) { Zpool.new('tank') }

      before do
        Zpool.any_instance.stub(:`).and_return('')
      end

      it 'raises an error on empty pool name' do
        [nil, ''].each do |name|
          expect { Zpool.new(name) }.to raise_error /missing pool name/
        end
      end

      describe '#name' do
        it 'returns the pool name' do
          expect(zpool.name).to eq('tank')
        end
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

      describe '#health' do
        it 'returns and caches the health by command-line' do
          zpool.should_receive(:`).with('zpool list -H -o health tank').
            once.and_return("ONLINE\n")
          2.times { expect(zpool.health).to eq('ONLINE') }
        end

        it 'raises an error with an unknown health' do
          zpool.stub(:`).and_return("SICK\n")
          expect { zpool.health }.to raise_error /unknown health: SICK/
        end

        it 'raises an error when the command returns a non-zero exit code'
      end
    end
  end
end
