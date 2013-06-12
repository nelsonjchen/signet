require 'signet/client'

module Signet
  class ClientCLI

    def self.run
      new.run
    end

    def run
      Client.new
    end
  end
end
