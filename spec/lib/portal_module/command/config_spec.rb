require 'pathname'
require Pathname(__FILE__).ascend{|d| h=d+'spec_helper.rb'; break h if h.file?}

describe 'config command' do

  before do
    # Reset config to a known state.
    PortalModule.configuration.reset
    # Delete any config file that may have been created.
    file = Pathname.pwd + '.portal_module'
    file.delete if file.exist?
  end

  let(:cli) { PortalModule::CLI }

  it "returns help info" do
    output = capture_output do
      cli.start %w(help config)
    end

    expect( output ).to include "config help [COMMAND]"
    expect( output ).to include "config add [CATEGORY]"
    expect( output ).to include "config show [CATEGORY]"
    expect( output ).to include "config del [CATEGORY]"
    expect( output ).to include "config init"
    expect( output ).to include "config timeout <seconds>"
    expect( output ).to include "config defenv <envname>"
    expect( output ).to include "config download_dir <dir>"
  end

  context 'config init' do

    context "no filename/path provided" do
      it "writes a configuration file to the current working directory" do
        with_target_dir('config/init') do |working_dir|
          output = capture_output do
            run_with_args %w(config init)
          end

          output_file = Pathname(working_dir) + '.portal_module'

          expect( output ).to include "configuration written to #{output_file.to_s}"
          expect( output_file.exist? ).to eq true
        end
      end
    end

    context "filename/path provided" do
      it "writes a configuration file to the specified directory" do
        with_target_dir('config/init') do |working_dir|
          final_dir = clean_target_dir(working_dir + 'nested/dir')

          output = capture_output do
            run_with_args %W(config init #{final_dir.to_s})
          end

          output_file = Pathname(final_dir) + '.portal_module'

          expect( output_file.exist? ).to eq true
          expect( output ).to include "configuration written to #{output_file.to_s}"
        end
      end
    end
  end

  context 'config timeout' do

    it "returns the current timeout when no argument provided" do
      with_target_dir('config/timeout') do
        run_with_args %w(config init -q)

        output = capture_output do
          run_with_args %w(config timeout)
        end

        expect( output ).to include 'browser timeout: 360'
      end
    end

    it "sets the current timeout when an argument is provided" do
      with_target_dir('config/timout') do
        run_with_args %w(config init -q)

        run_with_args %w(config timeout 180)

        expect( PortalModule.configuration.browser_timeout ).to eq 180
      end
    end

    it "displays an argument error if timeout value is not an integer" do
      with_target_dir('config/timeout') do
        output = capture_output do
          run_with_args %w(config timeout blag)
        end

        expect( output ).to include 'argument error: seconds must be an integer'
      end
    end
  end

  context 'config defenv' do

    it "returns the current default environment when no argument provided" do
      with_target_dir('config/defenv') do
        run_with_args %w(config init -q)

        run_with_args %w(config add env test1 http://example.com)
        run_with_args %w(config defenv test1)

        output = capture_output do
          run_with_args %w(config defenv)
        end

        expect( output ).to include 'default environment: test1'
      end
    end

    it "sets the current default environment when an argument is provided" do
      with_target_dir('config/defenv') do
        run_with_args %w(config init -q)

        run_with_args %w(config add env test2 http://example.com)
        run_with_args %w(config defenv test2)

        expect( PortalModule.configuration.default_environment ).to eq :test2
      end
    end

    it "displays an argument error if environment doesn't exist" do
      with_target_dir('config/defenv') do
        run_with_args %w(config init -q)

        output = capture_output do
          run_with_args %w(config defenv nope)
        end

        expect( output ).to include "argument error: environment 'nope' has not been configured"
      end
    end
  end

  context 'config download_dir' do

    it "returns the current download_dir when no argument provided" do
      with_target_dir('config/download_dir') do
        run_with_args %w(config init -q)

        run_with_args %w(config download_dir test1)

        output = capture_output do
          run_with_args %w(config download_dir)
        end

        expect( output ).to include 'download dir: test1'
      end
    end

    it "sets the current download_dir when an argument is provided" do
      with_target_dir('config/download_dir') do
        run_with_args %w(config init -q)

        run_with_args %w(config download_dir test2)

        expect( PortalModule.configuration.download_dir ).to eq 'test2'
      end
    end
  end

  context 'config add' do

    it "returns help info" do
      output = capture_output do
        run_with_args %w(config help add)
      end

      expect( output ).to include "add help [COMMAND]"
      expect( output ).to include "add env <envname> <url>"
      expect( output ).to include "add org <orgname> <orgid>"
      expect( output ).to include "add credentials <envname> <username> <pass>"
    end

    context "env" do

      it "adds an environment" do
        with_target_dir('config/add/env') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test http://example.com)

          actual = PortalModule.configuration.base_urls[:test]
          expect( actual ).to eq 'http://example.com'
        end
      end

      it "displays an error if environment already exists" do
        with_target_dir('config/add/env') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test http://example.com)

          output = capture_output do
            run_with_args %w(config add env test http://example.com)
          end

          expect( output ).to include "environment 'test' already exists"
        end
      end
    end

    context "org" do

      it "adds an org unit and ID" do
        with_target_dir('config/add/org') do
          run_with_args %w(config init -q)

          run_with_args ['config', 'add', 'org', 'Test Org', '1']

          actual = PortalModule.configuration.orgs['Test Org']
          expect( actual ).to eq '1'
        end
      end

      it "displays an error if Org Unit already exists" do
        org = 'Test Org'
        with_target_dir('config/add/org') do
          run_with_args %w(config init -q)

          run_with_args ['config', 'add', 'org', org, '1']

          output = capture_output do
            run_with_args ['config', 'add', 'org', org, '1']
          end

          expect( output ).to include "org unit 'Test Org' already exists"
        end
      end
    end

    context "credentials" do

      it "adds a set of credentials" do
        with_target_dir('config/add/credentials') do
          run_with_args %w(config init -q)

          # Add an environment first...
          run_with_args %w(config add env test http://example.com)

          run_with_args %w(config add credentials test testuser testpass)

          actual_user, actual_pass = PortalModule.configuration.credentials[:test]
          expect( actual_user ).to eq 'testuser'
          expect( actual_pass ).to eq 'testpass'
        end
      end

      it "displays an error if credentials already exist for the given env" do
        with_target_dir('config/add/credentials') do
          run_with_args %w(config init -q)

          # Add an environment first...
          run_with_args %w(config add env test http://example.com)

          run_with_args %w(config add credentials test testuser testpass)

          output = capture_output do
            run_with_args %w(config add credentials test testuser testpass)
          end

          expect( output ).to include "credentials already exist for environment 'test'"
        end
      end

      it "displays an error if environment hasn't been created first" do
        with_target_dir('config/add/credentials') do
          run_with_args %w(config init -q)

          output = capture_output do
            run_with_args %w(config add credentials test testuser testpass)
          end

          expect( output ).to include "environment 'test' doesn't exist"
          expect( output ).to include "create environment before adding credentials"
          expect( PortalModule.configuration.credentials.key?(:test) ).to be false
        end
      end
    end
  end

  context 'config show' do

    it "returns help info" do
      output = capture_output do
        run_with_args %w(config help show)
      end

      expect( output ).to include "show help [COMMAND]"
      expect( output ).to include "show envs"
      expect( output ).to include "show orgs"
      expect( output ).to include "show credentials <envname>"
    end

    context "orgs" do

      it "displays configured Org Unis" do
        with_target_dir('config/show/orgs') do
          run_with_args %w(config init -q)

          run_with_args %w(config add org test1 1)
          run_with_args %w(config add org test2 2)

          output = capture_output do
            run_with_args %w(config show orgs)
          end

          expect( output ).to include 'Org Units:'
          expect( output ).to include 'test1  1'
          expect( output ).to include 'test2  2'
        end
      end
    end

    context "envs" do

      it "displays configured environments" do
        with_target_dir('config/show/environments') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test1 http://example.com)
          run_with_args %w(config add env test2 http://example.org)

          output = capture_output do
            run_with_args %w(config show envs)
          end

          expect( output ).to include 'Environments:'
          expect( output ).to include 'test1  http://example.com'
          expect( output ).to include 'test2  http://example.org'
        end
      end
    end

    context "credentials" do

      it "displays configured credentials" do
        with_target_dir('config/show/credentials') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test1 http://example.com)
          run_with_args %w(config add credentials test1 testuser1 testpass1)

          run_with_args %w(config add env test2 http://example.org)
          run_with_args %w(config add credentials test2 testuser2 testpass2)

          output = capture_output do
            run_with_args %w(config show credentials)
          end

          expect( output ).to include 'credentials:'
          expect( output ).to include 'test1  testuser1  testpass1'
          expect( output ).to include 'test2  testuser2  testpass2'
        end
      end

      it "displays configured credentials for specified environment" do
        with_target_dir('config/show/credentials') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test1 http://example.com)
          run_with_args %w(config add credentials test1 testuser1 testpass1)

          run_with_args %w(config add env test2 http://example.org)
          run_with_args %w(config add credentials test2 testuser2 testpass2)

          output = capture_output do
            run_with_args %w(config show credentials test1)
          end

          expect( output ).to include 'credentials:'
          expect( output ).to include 'test1  testuser1  testpass1'
          expect( output ).to_not include 'test2  testuser2  testpass2'
        end
      end
    end
  end

  context 'config del' do

    it "returns help info" do
      output = capture_output do
        run_with_args %w(config help del)
      end

      expect( output ).to include "del help [COMMAND]"
      expect( output ).to include "del env <envname>"
      expect( output ).to include "del org <orgname>"
      expect( output ).to include "del credentials <envname>"
    end

    context "env" do

      it "deletes an existing environment" do
        with_target_dir('config/del/env') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test1 http://example.com)

          run_with_args %w(config del env test1)

          expect( PortalModule.configuration.base_urls.key?(:test1) ).to be false
        end
      end

      it "deletes matching credentials when deleting an environment" do
        with_target_dir('config/del/env') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test1 http://example.com)
          run_with_args %w(config add credentials test1 testuser1 testpass1)

          run_with_args %w(config del env test1)

          expect( PortalModule.configuration.base_urls.key?(:test1) ).to be false
          expect( PortalModule.configuration.credentials.key?(:test1) ).to be false
        end
      end
    end

    context "org" do

      it "deletes an existing Org Unit" do
        with_target_dir('config/del/org') do
          run_with_args %w(config init -q)

          run_with_args %w(config add org test1 1)

          run_with_args %w(config del org test1)

          expect( PortalModule.configuration.orgs.key?('test1') ).to be false
        end
      end
    end

    context "credentials" do

      it "deletes existing credentials" do
        with_target_dir('config/del/credentials') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test1 http://example.com)
          run_with_args %w(config add credentials test1 testuser1 testpass1)

          run_with_args %w(config del credentials test1)

          expect( PortalModule.configuration.credentials.key?(:test1) ).to be false
        end
      end

      it "does not delete matching environment when deleting credentials" do
        with_target_dir('config/del/credentials') do
          run_with_args %w(config init -q)

          run_with_args %w(config add env test1 http://example.com)
          run_with_args %w(config add credentials test1 testuser1 testpass1)

          run_with_args %w(config del credentials test1)

          expect( PortalModule.configuration.base_urls.key?(:test1) ).to be true
          expect( PortalModule.configuration.credentials.key?(:test1) ).to be false
        end
      end
    end
  end
end

