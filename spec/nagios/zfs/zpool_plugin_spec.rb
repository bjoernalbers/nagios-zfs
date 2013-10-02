require 'spec_helper'

module Nagios
  module ZFS
    describe ZpoolPlugin do
      let(:plugin) { ZpoolPlugin.new }
      let(:argv)   { [] }

      before do
        ZpoolPlugin.any_instance.stub(:argv).and_return(argv)
      end

      describe '#critical?' do
        it 'returns true when capacity is critical' do
          plugin.should_receive(:critical_capacity?).and_return(true)
          expect(plugin.critical?).to be(true)
        end

        it 'returns false when capacity is not critical' do
          plugin.should_receive(:critical_capacity?).and_return(false)
          expect(plugin.critical?).to be(false)
        end
      end

      describe '#critical_capacity?' do
        let(:zpool) { double('zpool') }

        before do
          plugin.stub(:zpool).and_return(zpool)
          plugin.stub(:config).and_return({:critical => 80})
        end

        it 'returns true when capacity exceeds critical threshold' do
          zpool.should_receive(:capacity).and_return(80)
          expect(plugin.send(:critical_capacity?)).to be(true)
        end

        it 'returns false when capacity does not exceed critical threshold' do
          zpool.should_receive(:capacity).and_return(79)
          expect(plugin.send(:critical_capacity?)).to be(false)
        end
      end

      describe '#warning?' do
        it 'returns true when capacity is warning' do
          plugin.should_receive(:warning_capacity?).and_return(true)
          expect(plugin.warning?).to be(true)
        end

        it 'returns false when capacity is not warning' do
          plugin.should_receive(:warning_capacity?).and_return(false)
          expect(plugin.warning?).to be(false)
        end
      end

      describe '#warning_capacity?' do
        let(:zpool) { double('zpool') }

        before do
          plugin.stub(:zpool).and_return(zpool)
          plugin.stub(:config).and_return({:warning => 80})
        end

        it 'returns true when capacity exceeds warning threshold' do
          zpool.should_receive(:capacity).and_return(80)
          expect(plugin.send(:warning_capacity?)).to be(true)
        end

        it 'returns false when capacity does not exceed warning threshold' do
          zpool.should_receive(:capacity).and_return(79)
          expect(plugin.send(:warning_capacity?)).to be(false)
        end
      end

      describe '#ok?' do
        it 'always returns true' do
          expect(plugin.ok?).to eq(true)
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
          name = 'tank'
          context "with #{opt} #{name}" do
            let(:argv) { [opt, name] }

            it { expect(plugin.config[:zpool]).to eq(name) }
          end
        end

        %w(-c --critical).each do |opt|
          threshold = 42
          context "with #{opt} #{threshold}" do
            let(:argv) { [opt, threshold.to_s] }

            it { expect(plugin.config[:critical]).to eq(threshold) }
          end
        end

        %w(-w --warning).each do |opt|
          threshold = 42
          context "with #{opt} #{threshold}" do
            let(:argv) { [opt, threshold.to_s] }

            it { expect(plugin.config[:warning]).to eq(threshold) }
          end
        end
      end
    end
  end
end