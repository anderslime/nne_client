module NNEClient
  # @!visibility private
  class Request
    class << self
      def execute(command, &block)
        new(command).result_set(&block)
      end
    end

    def initialize(command)
      @command = command
    end

    def result_set(&block)
      ResultSet.new(perform_request(&block))
    end

    private

    def perform_request(&block)
      client.request('wsdl', @command, request_attributes) do
        if false
          # Savon 0.9.5 does not support this
          soap.body do |xml|
            yield xml
          end
        else
          # So create a builder manually
          str = StringIO.new
          builder = Builder::XmlMarkup.new(:target => str)
          yield builder
          str.rewind
          soap.body = str.read
        end
      end
    end

    def request_attributes
      { "env:encodingStyle" => "http://schemas.xmlsoap.org/soap/encoding/" }
    end

    def client
      @client ||= Savon::Client.new do
        wsdl.document = File.expand_path("../../../wsdl/nne.wsdl", __FILE__)
      end
      @client.http.read_timeout = NNEClient.config.http_read_timeout
      @client
    end
  end
end
