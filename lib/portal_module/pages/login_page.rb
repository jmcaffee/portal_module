##############################################################################
# File::    login_page.rb
# Purpose:: Login page for Portal Module
#
# Author::    Jeff McAffee 2015-03-28
##############################################################################

require 'page-object'

module PortalModule::Pages

class LoginPage
  include PageObject

  page_url(:get_dynamic_url)

  def get_dynamic_url
    PortalModule.configuration.base_url
  end

  text_field(:username, :id => "ctl00_cntPlh_txtUserName" )
  text_field(:password_mask, :id => "ctl00_cntPlh_txtPasswordMask" )
  text_field(:password, :id => "ctl00_cntPlh_txtPassword" )
  button(:login, :id => "ctl00_cntPlh_btnLogin" )

  def login_as(username, password)
    if !self.username? && current_url == PortalModule.configuration.base_url + '/User/AppLogin.aspx'
      # We're still logged in.
      return
    end

    raise ArgumentError.new("Missing username for login.\nHave you set the HSBC_envname_USER environment variable?") if username.nil?

    raise ArgumentError.new("Missing password for login.\nHave you set the HSBC_envname_PASSWORD environment variable?") if password.nil?

    unless current_url.downcase.include? get_dynamic_url.downcase
      navigate_to get_dynamic_url
    end

    self.username = username

    allow_password_entry

    self.password = password
    login
  end

  def logout
    navigate_to get_dynamic_url + '/User/AppLogout.aspx'
  end

  def allow_password_entry
    # We used to have to click on the password mask before the page would let us enter the password itself:
    #
    # # For some unknown reason, we must click on a password mask input before
    # # we can access the password field itself.
    #   password_mask_element.click
    #
    # Now, we have to use javascript to hide the mask and display the password field.
    hide_mask_script = <<EOS
pwdmasks = document.getElementsByClassName('passwordmask');
pwdmasks[0].style.display = 'none';
pwds = document.getElementsByClassName('password');
pwds[0].style.display = 'block';
EOS

    @browser.execute_script(hide_mask_script)
  end

end

end # module Pages

