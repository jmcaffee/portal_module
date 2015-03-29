require 'spec_helper'

describe 'command dts' do

  let(:page_factory) do
    obj = MockPageFactory.new
  end

  let(:client) do
    obj = mock_client(page_factory)
  end

  let(:dts_mock) do
    obj = mock_dts(page_factory)
  end

  before do
    PortalModule.configure do |config|
      config.credentials[:dev] = ['user', 'pass']
      config.download_dir = spec_tmp_dir('downloads')
      config.orgs['Test Org'] = '1'
    end
  end

  it "returns help info" do
    output = capture_output do
      run_with_args %w(help dts)
    end

    expect( output ).to include "dts help [COMMAND]"
    expect( output ).to include "dts upload <org> <filepath>"
    expect( output ).to include "dts download <org> <filepath>"
    expect( output ).to include "e, [--environment=dev]"
  end

  context "upload" do
    it "uploads a DTS configuration file to the portal" do
      file_path = (spec_data_dir() + 'dts_upload.xml').to_s

      expect(client)
        .to receive(:user=)
        .with('user')

      expect(client)
        .to receive(:password=)
        .with('pass')

      expect(client)
        .to receive(:env=)
        .with('dev')

      expect(client)
        .to receive(:dts)
        .and_return(dts_mock)

      expect(dts_mock)
        .to receive(:upload)
        .with('Test Org', file_path)

      expect(client)
        .to receive(:logout)

      run_with_args ['dts', 'upload', '-e', 'dev', 'Test Org', file_path], client
    end
  end

  context "download" do
    it "downloads a DTS configuration file from the portal" do
      file_path = (spec_tmp_dir('dts/downlod') + 'dts_download.xml').to_s

      expect(client)
        .to receive(:user=)
        .with('user')

      expect(client)
        .to receive(:password=)
        .with('pass')

      expect(client)
        .to receive(:env=)
        .with('dev')

      expect(client)
        .to receive(:dts)
        .and_return(dts_mock)

      expect(dts_mock)
        .to receive(:download)
        .with('Test Org', file_path)

      expect(client)
        .to receive(:logout)

      run_with_args ['dts', 'download', '-e', 'dev', 'Test Org', file_path], client
    end
  end
end

