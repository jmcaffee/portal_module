require 'spec_helper'

describe PortalModule::Dts do

  ##
  # Copy a dummy file to the 'downloads' directory to simulate that
  # a download has occurred.
  #

  def generate_dl_file
    FileUtils.cp spec_data_dir + 'dts_import.xml', spec_tmp_dir('downloads') + '2-LatestDTS.xml'
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

    context "#save" do
      it "saves the current configuration" do
        expect(page_factory.dts_page)
          .to receive(:save)

        dts = PortalModule::Dts.new(page_factory)
        dts = dts.save()
      end
    end

    context "#activate" do
      it "activates the current configuration" do
        expect(page_factory.dts_page)
          .to receive(:activate)

        dts = PortalModule::Dts.new(page_factory)
        dts = dts.activate()
      end
    end

    context "#download" do
      context "dest path dir exists" do
        it "downloads a configuration" do
          dest_file = spec_tmp_dir('dts') + 'export.xml'

          page_obj = page_factory.dts_page
          expect(page_obj)
            .to receive(:load_org)
            .with(valid_org)
            .and_return(page_obj)

          expect(page_factory.dts_page)
            .to receive(:download)
            .and_return(generate_dl_file)

          dts = PortalModule::Dts.new(page_factory)
          dts.download(valid_org, dest_file)

          expect(File.exist?(dest_file)).to eq true
        end
      end

      context "dest path does not exist" do
        it "raises exception" do
          dest_path = 'not/a/real/dir/export.xml'

          expect(page_factory.dts_page)
            .not_to receive(:load_org)

          expect(page_factory.dts_page)
            .not_to receive(:download)

          dts = PortalModule::Dts.new(page_factory)
          expect { dts.download(valid_org, dest_path) }.to raise_exception /No such directory - #{dest_path}/
        end
      end
    end

    context "#upload" do
      context "file exists" do
        it "uploads the DTS definition" do
          src_path = spec_data_dir + 'dts_import.xml'

          page_obj = page_factory.dts_page
          expect(page_obj)
            .to receive(:load_org)
            .with(valid_org)
            .and_return(page_obj)

          expect(page_factory.dts_page)
            .to receive(:upload)
            .with(src_path)

          dts = PortalModule::Dts.new(page_factory)
          dts.upload(valid_org, src_path)
        end
      end

      context "file does not exist" do
        it "raises exception" do
          src_path = 'not/a/real/dir/import.xml'

          expect(page_factory.dts_page)
            .not_to receive(:load_org)

          expect(page_factory.dts_page)
            .not_to receive(:upload)

          dts = PortalModule::Dts.new(page_factory)
          expect { dts.upload(valid_org, src_path) }.to raise_exception /File not found: #{src_path}/
        end
      end
    end

    context "#set_org" do
      context "org has been configured" do
        it "changes the Org Unit" do
          expect(page_factory.dts_page)
            .to receive(:load_org)
            .with(valid_org)

          dts = PortalModule::Dts.new(page_factory)
          dts.set_org(valid_org)
        end
      end

      context "org has not been configured" do
        it "raises exception" do
          dts = PortalModule::Dts.new(page_factory)
          expect { dts.set_org(invalid_org) }.to raise_exception /Org Unit has not been configured - #{invalid_org}/
        end
      end
    end
  end
end

