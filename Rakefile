require "bundler/gem_tasks"
require 'ktutils/os'

desc 'start a console'
task :console do
  require 'pry'
  require 'portal_module'
  ARGV.clear

  PortalModule.configure do |config|
    config.credentials = { :dev => ['admin', 'Password1*'] }
  end

  def console_help
    puts <<CONSOLE_HELP
 CONSOLE HELP
-------------

'cli' returns an initialized CLI object

    The default environment is :dev.
    To interact with a different environment, add credentials
    and activate the new environment:

    Ex:
      add_credentials ENV, USERNAME, PASSWORD
      cli.environment = :ENV
      cli.login

    or, call 'activate_env ENV, USERNAME, PASSWORD'


Avaliable commands/methods:

  cli
  add_credentials ENV, USERNAME, PASSWORD
  activate_env ENV, USERNAME, PASSWORD
  add_org ORG_NAME, ORG_ID
  console_help

CONSOLE_HELP
  end

  def cli
    @cli ||= PortalModule::CLI.new
    @cli
  end

  def add_credentials env, username, pwd
    PortalModule.configure do |config|
      config.credentials[env.to_sym] = [username, pwd]
    end
  end

  def activate_env env, username, pwd
    add_credentials env, username, pwd
    cli.environment = env.to_sym
  end

  def add_org org, id
    PortalModule.configure do |config|
      config.orgs[org] = id
    end
  end

  console_help
  Pry.start
end

desc 'Start chrome with data dir'
task :start_chrome do
  user_data_dir = File.expand_path('test/chrome-data')
  mkdirs user_data_dir unless File.exists?(user_data_dir) and File.directory?(user_data_dir)

  if Ktutils::OS.windows?
    chrome_path = '"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"'
    win_user_data_dir = user_data_dir.gsub('/','\\')
    cmd = chrome_path + ' --user-data-dir=' + win_user_data_dir

    sh(cmd)
  else
    chrome = `which chromium-browser`.chomp

    sh("#{chrome} --user-data-dir=#{user_data_dir}")
  end
end

