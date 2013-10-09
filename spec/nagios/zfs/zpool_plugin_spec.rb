require 'spec_helper'

module Nagios
  module ZFS
    describe ZpoolPlugin do
      let(:plugin) { ZpoolPlugin.new }
      let(:argv)   { %w(--pool tank) }

      before do
        ZpoolPlugin.any_instance.stub(:argv).and_return(argv)
      end

      context 'without required arguments' do
        let(:argv) { [] }

        it 'raises an error without pool name' do
          ZpoolPlugin.any_instance.stub(:puts) # Don't mess up our spec output.
          expect { plugin }.to raise_error(SystemExit)
        end
      end

      describe '#critical?' do
        before do
          plugin.stub(:critical_capacity?).and_return(false)
          plugin.stub(:critical_health?).and_return(false)
        end

        it 'is true when capacity is critical' do
          plugin.should_receive(:critical_capacity?).and_return(true)
          expect(plugin.critical?).to be(true)
        end

        it 'is true when health is critical' do
          plugin.should_receive(:critical_health?).and_return(true)
          expect(plugin.critical?).to be(true)
        end

        it 'is false when capacity is not critical' do
          plugin.should_receive(:critical_capacity?).and_return(false)
          expect(plugin.critical?).to be(false)
        end

        it 'is false when health is not critical' do
          plugin.should_receive(:critical_health?).and_return(false)
          expect(plugin.critical?).to be(false)
        end

      end

      describe '#warning?' do
        before do
          plugin.stub(:warning_capacity?).and_return(false)
          plugin.stub(:warning_health?).and_return(false)
        end

        it 'is true when capacity is warning' do
          plugin.should_receive(:warning_capacity?).and_return(true)
          expect(plugin.warning?).to be(true)
        end

        it 'is true when health is warning' do
          plugin.should_receive(:warning_health?).and_return(true)
          expect(plugin.warning?).to be(true)
        end

        it 'is false when capacity is not warning' do
          plugin.should_receive(:warning_capacity?).and_return(false)
          expect(plugin.warning?).to be(false)
        end

        it 'is false when health is not warning' do
          plugin.should_receive(:warning_health?).and_return(false)
          expect(plugin.warning?).to be(false)
        end
      end

      describe '#critical_capacity?' do
        let(:zpool) { double('zpool') }

        before do
          plugin.stub(:zpool).and_return(zpool)
          plugin.stub(:config).and_return({:critical => 80})
        end

        it 'is true when capacity exceeds critical threshold' do
          zpool.should_receive(:capacity).and_return(80)
          expect(plugin.send(:critical_capacity?)).to be(true)
        end

        it 'is false when capacity does not exceed critical threshold' do
          zpool.should_receive(:capacity).and_return(79)
          expect(plugin.send(:critical_capacity?)).to be(false)
        end
      end

      describe '#warning_capacity?' do
        let(:zpool) { double('zpool') }

        before do
          plugin.stub(:zpool).and_return(zpool)
          plugin.stub(:config).and_return({:warning => 80})
        end

        it 'is true when capacity exceeds warning threshold' do
          zpool.should_receive(:capacity).and_return(80)
          expect(plugin.send(:warning_capacity?)).to be(true)
        end

        it 'is false when capacity does not exceed warning threshold' do
          zpool.should_receive(:capacity).and_return(79)
          expect(plugin.send(:warning_capacity?)).to be(false)
        end
      end

      describe '#critical_health?' do
        let(:zpool) { double('zpool') }

        before { plugin.stub(:zpool).and_return(zpool) }

        it 'is true with a faulted pool' do
          zpool.should_receive(:health).and_return('FAULTED')
          expect(plugin.send(:critical_health?)).to be(true)
        end

        it 'is false without a faulted pool' do
          zpool.should_receive(:health).and_return('DEGRADED')
          expect(plugin.send(:critical_health?)).to be(false)
        end
      end

      describe '#warning_health?' do
        let(:zpool) { double('zpool') }

        before { plugin.stub(:zpool).and_return(zpool) }

        it 'is true with a degraded pool' do
          zpool.should_receive(:health).and_return('DEGRADED')
          expect(plugin.send(:warning_health?)).to be(true)
        end

        it 'is false without a degraded pool' do
          zpool.should_receive(:health).and_return('ONLINE')
          expect(plugin.send(:warning_health?)).to be(false)
        end
      end

      describe '#ok?' do
        it 'always returns true' do
          expect(plugin.ok?).to eq(true)
        end
      end

      describe '#message' do
        it 'includes the pool name, health and capcity' do
          zpool = double('zpool')
          zpool.should_receive(:name).and_return('tank')
          zpool.should_receive(:health).and_return('ONLINE')
          zpool.should_receive(:capacity).and_return(42)
          plugin.stub(:zpool).and_return(zpool)
          expect(plugin.message).to eq('tank ONLINE (42%)')
        end
      end

      describe '#zpool' do
        let(:zpool) { double('zpool') }

        before do
          plugin.stub(:config).and_return({:zpool => 'tank'})
        end

        it 'returns and caches the zpool' do
          Zpool.should_receive(:new).with('tank').once.and_return(zpool)
          expect(plugin.send(:zpool)).to eq(zpool)
          expect(plugin.send(:zpool)).to eq(zpool)
        end
      end

      describe '#config' do
        %w(-p --pool).each do |opt|
          context "with #{opt}" do
            before { argv << opt << 'tank' }

            it { expect(plugin.config[:zpool]).to eq('tank') }
          end
        end

        %w(-c --critical).each do |opt|
          threshold = 42
          context "with #{opt}" do
            before { argv << opt << threshold.to_s }

            it { expect(plugin.config[:critical]).to eq(threshold) }
          end
        end

        %w(-w --warning).each do |opt|
          threshold = 42
          context "with #{opt}" do
            before { argv << opt << threshold.to_s }

            it { expect(plugin.config[:warning]).to eq(threshold) }
          end
        end
      end
    end
  end
end
