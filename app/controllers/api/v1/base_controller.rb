class Api::V1::BaseController < ActionController::API
    
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    
    def not_found
        return api_error(status: 404, errors: 'Not found')
    end

    protected
        def paginate(resource)
            p params[:page]
            p params[:per_page]
            resource = resource.page(params[:page] || 1)
            if params[:per_page]
                resource = resource.per_page(params[:per_page])
            end
    
            return resource
        end
    
        #expects paginated resource!
        def meta_attributes(object)
            {
                current_page: object.current_page,
                next_page: object.next_page,
                prev_page: object.previous_page,
                total_pages: object.total_pages,
                total_count: object.total_entries
            }
        end

        def api_error(status: 500, errors: [])
            puts errors.full_messages if errors.respond_to?(:full_messages)
      
            render json: Api::V1::ErrorSerializer.new(status, errors).as_json,
              status: status
        end
end