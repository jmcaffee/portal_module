require 'spec_helper'

describe PortalModule::Client do

  before(:each) do
    PortalModule.configure do |config|
      config.reset
      config.credentials[:dev] = ['devuser', 'devpass']
    end
  end

  let(:client) do
    obj = PortalModule::Client.new
    obj.page_factory = mock_page_factory
    obj
  end

  let(:login_page) { client.page_factory.login_page }

  context "#env=" do

    before(:each) do
      PortalModule.configure do |config|
        config.reset
        config.credentials[:sit] = ['user', 'pass']
        config.base_urls[:sit] = 'http://example.com/Portal'
      end
    end

    it "sets environment to use" do
      expect{ client.env = 'sit' }.to_not raise_exception
      expect( client.env ).to eq :sit
    end

    it "raises exception if environment is not configured" do
      expect{ client.env = :test }.to raise_exception
    end
  end

  context "#env" do
    it "returns default environment if not set" do
      expect( client.env ).to eq PortalModule.configuration.default_environment
    end
  end

  context "#dts" do
    it "logs into the current env and returns a pre-configured Dts object" do

      expect(login_page)
        .to receive(:login_as)
        .with('testuser', 'testpass')

      client.user = 'testuser'
      client.password = 'testpass'

      expect( client.dts ).to_not be nil
    end
  end

  context "#loan_entry" do
    it "logs into the current env and returns a pre-configured LoanEntry object" do

      expect(login_page)
        .to receive(:login_as)
        .with('testuser', 'testpass')

      client.user = 'testuser'
      client.password = 'testpass'

      expect( client.loan_entry ).to_not be nil
    end
  end

  context "#login" do
    context "credentials not passed" do

      before(:each) do
        PortalModule.configure do |config|
          config.reset
          config.credentials[:dev] = ['devuser', 'devpass']
          config.base_urls[:dev] = 'http://example.com/Portal'
        end
      end

      let(:client) do
        obj = PortalModule::Client.new
        obj.page_factory = mock_page_factory
        obj
      end

      it "uses credentials from configuration data" do
        expect(login_page)
          .to receive(:login_as)
          .with('devuser', 'devpass')

        client.env = :dev
        client.login
      end

      it "credentials set on client override configuration data credentials" do
        expect(login_page)
          .to receive(:login_as)
          .with('clientuser', 'clientpass')

        client.env = :dev
        client.user = 'clientuser'
        client.password = 'clientpass'
        client.login
      end

      it "raises AuthenticationRequired when no credentials are available" do
        PortalModule.configure do |config|
          config.credentials.delete :dev
        end

        client.env = :dev
        client.user = nil
        client.password = nil

        expect{ client.login }.to raise_exception AuthenticationRequired
      end
    end

  end
end

