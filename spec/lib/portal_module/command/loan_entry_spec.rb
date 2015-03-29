require 'spec_helper'

describe 'command loan_entry' do

  let(:page_factory) do
    obj = MockPageFactory.new
  end

  let(:client) do
    obj = mock_client(page_factory)
  end

  let(:le_mock) do
    obj = mock_loan_entry(page_factory)
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
      run_with_args %w(help loan_entry)
    end

    expect( output ).to include "loan_entry help [COMMAND]"
    expect( output ).to include "loan_entry upload <org> <filepath>"
    expect( output ).to include "loan_entry download <org> <filepath>"
    expect( output ).to include "e, [--environment=dev]"
  end

  context "upload" do
    it "uploads a Loan Entry configuration file to the portal" do
      file_path = (spec_data_dir() + 'le_upload.xml').to_s

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
        .to receive(:loan_entry)
        .and_return(le_mock)

      expect(le_mock)
        .to receive(:upload)
        .with('Test Org', file_path)

      expect(client)
        .to receive(:logout)

      run_with_args ['loan_entry', 'upload', '-e', 'dev', 'Test Org', file_path], client
    end
  end

  context "download" do
    it "downloads a Loan Entry configuration file from the portal" do
      file_path = (spec_tmp_dir('loan_entry/downlod') + 'le_download.xml').to_s

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
        .to receive(:loan_entry)
        .and_return(le_mock)

      expect(le_mock)
        .to receive(:download)
        .with('Test Org', file_path)

      expect(client)
        .to receive(:logout)

      run_with_args ['loan_entry', 'download', '-e', 'dev', 'Test Org', file_path], client
    end
  end
end

