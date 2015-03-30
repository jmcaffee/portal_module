##############################################################################
# File::    data_transformation_page.rb
# Purpose:: DTS page for PortalModule
# 
# Author::    Jeff McAffee 2015-03-28
##############################################################################
require 'page-object'

module PortalModule::Pages
  class DataTransformationPage
    include PageObject

    # If page_url is not set, page_object will not navigate to this page
    # when visit is true.
    page_url(:get_dynamic_url)

    def get_dynamic_url
      PortalModule.configuration.url(DataTransformationPage)
    end

    span(:viewing_span,
          id: 'ctl00_ContentPlaceHolder1_lblOrganizationName')

    button(:save_button,
          id: 'ctl00_ContentPlaceHolder1_btnSave')

    button(:activate_button,
          id: 'ctl00_ContentPlaceHolder1_btnVersion')

    button(:download_button,
          id: 'ctl00_ContentPlaceHolder1_btnDownload')

    # Search Orgs
    text_field(:search_text,
          id: 'ctl00_ContentPlaceHolder1_txtSrchText')

    button(:search_button,
          id: 'ctl00_ContentPlaceHolder1_btnSearch')

    # File Upload
    file_field(:file_input,
          id: 'ctl00_ContentPlaceHolder1_FileUploader')

    button(:upload_button,
          id: 'ctl00_ContentPlaceHolder1_btnUploadXMLFile')


    def save
      self.save_button
      self
    end

    def activate
      self.activate_button
      self
    end

    def download
      self.download_button
      self
    end

    def load_org org_string
      org_name = org_string.split('~')[1]
      return self if viewing_span == org_name

      self.search_text = org_string
      self.search_button

      viewing_span_element.wait_until(120, "Org not loaded - #{org_name}") do
        viewing_span == org_name
      end

      self
    end

    def upload file_path
      self.file_input = file_path
      self.upload_button
      self
    end
  end
end # module Pages

