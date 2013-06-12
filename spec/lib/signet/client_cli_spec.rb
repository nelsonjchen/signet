require 'signet/client_cli'

module Signet

  describe ClientCLI do

    it 'works fine with no arguments'
    it 'accepts an optional URL argument'
    it 'accepts an optional config file argument'

    describe '::run' do
      it 'calls #run on a new instance' do
        ClientCLI.any_instance.should_receive(:run)
        ClientCLI.run
      end
    end

    describe '#run' do

      it 'creates a new Client' do
        Client.should_receive(:new)
        ClientCLI.run
      end
    end
  end
end
