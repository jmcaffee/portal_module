require 'spec_helper'

describe PortalModule::LoanEntry do

  ##
  # Copy a dummy file to the 'downloads' directory to simulate that
  # a download has occurred.
  #

  def generate_dl_file
    FileUtils.cp spec_data_dir + 'le_import.xml', spec_tmp_dir('downloads') + '2-LatestPrequal.xml'
  end

  context "api" do

    let(:page_factory) do
      obj = MockPageFactory.new
    end

    let(:valid_org) do
      PortalModule.configure do |c|
        c.orgs['Test Org'] = 1
        c.download_dir = spec_tmp_dir('downloads')
      end
      'Test Org'
    end

    let(:invalid_org) { 'Invalid Org' }

    context "#activate" do
      it "activates the current configuration" do
        expect(page_factory.loan_entry_page)
          .to receive(:activate)

        le = PortalModule::LoanEntry.new(page_factory)
        le = le.activate()
      end
    end

    context "#download" do
      context "file directory exists" do
        it "downloads a loan entry definition" do
          dest_file = spec_tmp_dir('loan_entry') + 'export.xml'

          page = page_factory.loan_entry_page
          expect(page)
            .to receive(:load_org)
            .with(valid_org)
            .and_return(page)

          expect(page)
            .to receive(:download)
            .and_return(generate_dl_file)

          le = PortalModule::LoanEntry.new(page_factory)
          le.download(valid_org, dest_file)

          expect(File.exist?(dest_file)).to eq true
        end
      end

      context "file directory does not exist" do
        it "raises exception" do
          dest_path = spec_tmp_dir('loan_entry') + 'not/a/real/dir/export.xml'

          page = page_factory.loan_entry_page
          expect(page)
            .not_to receive(:load_org)

          expect(page)
            .not_to receive(:download)

          le = PortalModule::LoanEntry.new(page_factory)
          expect { le.download(valid_org, dest_path) }.to raise_exception /No such directory - #{dest_path}/
        end
      end
    end

    context "#upload" do
      context "file exists" do
        it "uploads loan entry definitions" do
          src_file = spec_data_dir + 'le_import.xml'

          page = page_factory.loan_entry_page
          expect(page)
            .to receive(:load_org)
            .with(valid_org)
            .and_return(page)

          expect(page)
            .to receive(:upload)
            .with(src_file)

          le = PortalModule::LoanEntry.new(page_factory)
          le.upload valid_org, src_file
        end
      end

      context "file does not exist" do
        it "raises exception" do
          src_file = spec_data_dir + 'does_not_exist.xml'

          expect(page_factory.loan_entry_page)
            .not_to receive(:load_org)

          le = PortalModule::LoanEntry.new(page_factory)
          expect { le.upload(valid_org, src_file) }.to raise_exception /File not found: #{src_file}/
        end
      end
    end
  end
end

