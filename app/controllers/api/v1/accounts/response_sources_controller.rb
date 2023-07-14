class Api::V1::Accounts::ResponseSourcesController < Api::V1::Accounts::BaseController
  before_action :current_account
  before_action :check_authorization
  before_action :find_response_source, only: [:add_document, :remove_document]

  def parse
    links = PageCrawlerService.new(params[:link]).get_links
    render json: { links: links }
  end

  def create
    @response_source = Current.account.response_sources.new(response_source_params)
    @response_source.save!
    @response_source
  end

  def add_document
    @response_source.response_documents.create!(document_link: params[:document_link])
    @response_source
  end

  def remove_document
    @response_source.response_documents.find(params[:document_id]).destroy!
    @response_source
  end

  private

  def find_response_source
    @response_source = Current.account.response_sources.find(params[:id])
  end

  def response_source_params
    params.require(:response_source).permit(:name, :source_link, :inbox_id,
                                            response_documents_attributes: [:document_link])
  end
end
