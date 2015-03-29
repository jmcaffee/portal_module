include RSpec::Mocks::ExampleMethods

def mock_watir_browser
  watir_browser = instance_double('Watir::Browser')
  allow(watir_browser).to receive(:is_a?).with(anything()).and_return(false)
  allow(watir_browser).to receive(:is_a?).with(Watir::Browser).and_return(true)
  allow(watir_browser).to receive(:goto).with(anything()).and_return(true)
  allow(watir_browser).to receive(:text_field).with(anything()).and_return(nil)
  watir_browser
end

#
# Page Object Mocks
#

def mock_login_page(nav_to_page = true)
  login_page = object_double(PortalModule::Pages::LoginPage.new(mock_watir_browser, nav_to_page))
  allow(login_page).to receive(:login_as)#.with(anything()).and_return(nil)
  allow(login_page).to receive(:logout)#.with(anything()).and_return(nil)
  login_page
end

def mock_prequal_setup_page(nav_to_page = true)
  prequal_setup_page = object_double(PortalModule::Pages::PrequalSetupPage.new(mock_watir_browser, nav_to_page))
end

def mock_data_transformation_page(nav_to_page = true)
  obj = object_double(PortalModule::Pages::DataTransformationPage.new(mock_watir_browser, nav_to_page))
end

#
# Page Factory Mocks
#

def mock_page_factory_with_method(meth, obj)
  page_factory = instance_double('PortalModule::PageFactory')
  allow(page_factory).to receive(meth).and_return(obj)
  page_factory
end

def mock_page_factory
  obj = MockPageFactory.new
  obj.login_page = mock_login_page
  obj.loan_entry_page = mock_prequal_setup_page
  obj.dts_page = mock_data_transformation_page
  obj
end

class MockPageFactory

  attr_writer :login_page
  attr_writer :loan_entry_page
  attr_writer :dts_page

  def login_page(nav_to_page = true)
    @login_page ||= mock_login_page(nav_to_page)
  end

  def loan_entry_page(nav_to_page = true)
    @loan_entry_page ||= mock_prequal_setup_page(nav_to_page)
  end

  def dts_page(nav_to_page = true)
    @dts_page ||= mock_data_transformation_page(nav_to_page)
  end
end

#
# Mock Client Objects
#

def mock_client(pg_factory = MockPageFactory.new)
  mock_client = object_double(PortalModule::Client.new)

  allow(mock_client).to receive(:login).with(anything, anything).and_return(nil)
  allow(mock_client).to receive(:logout).and_return(nil)
  allow(mock_client).to receive(:quit).and_return(nil)
  allow(mock_client).to receive(:loan_entry).and_return(mock_loan_entry(pg_factory))
  allow(mock_client).to receive(:dts).and_return(mock_dts(pg_factory))

  mock_client
end

def mock_dts(pg_factory)
  mock_dts = object_double(PortalModule::Dts.new(pg_factory))

  allow(mock_dts).to receive(:activate).and_return(nil)
  allow(mock_dts).to receive(:save).and_return(nil)
  allow(mock_dts).to receive(:upload).and_return(nil)
  allow(mock_dts).to receive(:download).and_return(nil)
  allow(mock_dts).to receive(:set_org).and_return(nil)

  mock_dts
end

def mock_loan_entry(pg_factory)
  mock_obj = object_double(PortalModule::LoanEntry.new(pg_factory))

  allow(mock_obj).to receive(:activate).and_return(nil)
  allow(mock_obj).to receive(:upload).and_return(nil)
  allow(mock_obj).to receive(:download).and_return(nil)
  allow(mock_obj).to receive(:set_org).and_return(nil)

  mock_obj
end

