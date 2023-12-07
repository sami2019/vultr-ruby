=begin
#Vultr API

## Introduction  The Vultr API v2 is a set of HTTP endpoints that adhere to RESTful design principles and CRUD actions with predictable URIs. It uses standard HTTP response codes, authentication, and verbs. The API has consistent and well-formed JSON requests and responses with cursor-based pagination to simplify list handling. Error messages are descriptive and easy to understand. All functions of the Vultr customer portal are accessible via the API, enabling you to script complex unattended scenarios with any tool fluent in HTTP.  ## Requests  Communicate with the API by making an HTTP request at the correct endpoint. The chosen method determines the action taken.  | Method | Usage | | ------ | ------------- | | DELETE | Use the DELETE method to destroy a resource in your account. If it is not found, the operation will return a 4xx error and an appropriate message. | | GET | To retrieve information about a resource, use the GET method. The data is returned as a JSON object. GET methods are read-only and do not affect any resources. | | PATCH | Some resources support partial modification with PATCH, which modifies specific attributes without updating the entire object representation. | | POST | Issue a POST method to create a new object. Include all needed attributes in the request body encoded as JSON. | | PUT | Use the PUT method to update information about a resource. PUT will set new values on the item without regard to their current values. |  **Rate Limit:** Vultr safeguards the API against bursts of incoming traffic based on the request's IP address to ensure stability for all users. If your application sends more than 30 requests per second, the API may return HTTP status code 429.  ## Response Codes  We use standard HTTP response codes to show the success or failure of requests. Response codes in the 2xx range indicate success, while codes in the 4xx range indicate an error, such as an authorization failure or a malformed request. All 4xx errors will return a JSON response object with an `error` attribute explaining the error. Codes in the 5xx range indicate a server-side problem preventing Vultr from fulfilling your request.  | Response | Description | | ------ | ------------- | | 200 OK | The response contains your requested information. | | 201 Created | Your request was accepted. The resource was created. | | 202 Accepted | Your request was accepted. The resource was created or updated. | | 204 No Content | Your request succeeded, there is no additional information returned. | | 400 Bad Request | Your request was malformed. | | 401 Unauthorized | You did not supply valid authentication credentials. | | 403 Forbidden | You are not allowed to perform that action. | | 404 Not Found | No results were found for your request. | | 429 Too Many Requests | Your request exceeded the API rate limit. | | 500 Internal Server Error | We were unable to perform the request due to server-side problems. |  ## Meta and Pagination  Many API calls will return a `meta` object with paging information.  ### Definitions  | Term | Description | | ------ | ------------- | | **List** | The items returned from the database for your request (not necessarily shown in a single response depending on the **cursor** size). | | **Page** | A subset of the full **list** of items. Choose the size of a **page** with the `per_page` parameter. | | **Total** | The `total` attribute indicates the number of items in the full **list**.| | **Cursor** | Use the `cursor` query parameter to select a next or previous **page**. | | **Next** & **Prev** | Use the `next` and `prev` attributes of the `links` meta object as `cursor` values. |  ### How to use Paging  If your result **list** total exceeds the default **cursor** size (the default depends on the route, but is usually 100 records) or the value defined by the `per_page` query param (when present) the response will be returned to you paginated.  ### Paging Example  > These examples have abbreviated attributes and sample values. Your actual `cursor` values will be encoded alphanumeric strings.  To return a **page** with the first two plans in the List:      curl \"https://api.vultr.com/v2/plans?per_page=2\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  The API returns an object similar to this:      {         \"plans\": [             {                 \"id\": \"vc2-1c-2gb\",                 \"vcpu_count\": 1,                 \"ram\": 2048,                 \"locations\": []             },             {                 \"id\": \"vc2-24c-97gb\",                 \"vcpu_count\": 24,                 \"ram\": 98304,                 \"locations\": []             }         ],         \"meta\": {             \"total\": 19,             \"links\": {                 \"next\": \"WxYzExampleNext\",                 \"prev\": \"WxYzExamplePrev\"             }         }     }  The object contains two plans. The `total` attribute indicates that 19 plans are available in the List. To navigate forward in the **list**, use the `next` value (`WxYzExampleNext` in this example) as your `cursor` query parameter.      curl \"https://api.vultr.com/v2/plans?per_page=2&cursor=WxYzExampleNext\" \\       -X GET       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  Likewise, you can use the example `prev` value `WxYzExamplePrev` to navigate backward.  ## Parameters  You can pass information to the API with three different types of parameters.  ### Path parameters  Some API calls require variable parameters as part of the endpoint path. For example, to retrieve information about a user, supply the `user-id` in the endpoint.      curl \"https://api.vultr.com/v2/users/{user-id}\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  ### Query parameters  Some API calls allow filtering with query parameters. For example, the `/v2/plans` endpoint supports a `type` query parameter. Setting `type=vhf` instructs the API only to return High Frequency Compute plans in the list. You'll find more specifics about valid filters in the endpoint documentation below.      curl \"https://api.vultr.com/v2/plans?type=vhf\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  You can also combine filtering with paging. Use the `per_page` parameter to retreive a subset of vhf plans.      curl \"https://api.vultr.com/v2/plans?type=vhf&per_page=2\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  ### Request Body  PUT, POST, and PATCH methods may include an object in the request body with a content type of **application/json**. The documentation for each endpoint below has more information about the expected object.  ## API Example Conventions  The examples in this documentation use `curl`, a command-line HTTP client, to demonstrate useage. Linux and macOS computers usually have curl installed by default, and it's [available for download](https://curl.se/download.html) on all popular platforms including Windows.  Each example is split across multiple lines with the `\\` character, which is compatible with a `bash` terminal. A typical example looks like this:      curl \"https://api.vultr.com/v2/domains\" \\       -X POST \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\" \\       -H \"Content-Type: application/json\" \\       --data '{         \"domain\" : \"example.com\",         \"ip\" : \"192.0.2.123\"       }'  * The `-X` parameter sets the request method. For consistency, we show the method on all examples, even though it's not explicitly required for GET methods. * The `-H` lines set required HTTP headers. These examples are formatted to expand the VULTR\\_API\\_KEY environment variable for your convenience. * Examples that require a JSON object in the request body pass the required data via the `--data` parameter.  All values in this guide are examples. Do not rely on the OS or Plan IDs listed in this guide; use the appropriate endpoint to retreive values before creating resources. 

The version of the OpenAPI document: 2.0
Contact: support@vultr.com
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 7.2.0-SNAPSHOT

=end

require 'cgi'

module VultRuby
  class StartupApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create Startup Script
    # Create a new Startup Script. The `name` and `script` attributes are required, and scripts are base-64 encoded.
    # @param [Hash] opts the optional parameters
    # @option opts [CreateStartupScriptRequest] :create_startup_script_request Include a JSON object in the request body with a content type of **application/json**.
    # @return [GetStartupScript200Response]
    def create_startup_script(opts = {})
      data, _status_code, _headers = create_startup_script_with_http_info(opts)
      data
    end

    # Create Startup Script
    # Create a new Startup Script. The &#x60;name&#x60; and &#x60;script&#x60; attributes are required, and scripts are base-64 encoded.
    # @param [Hash] opts the optional parameters
    # @option opts [CreateStartupScriptRequest] :create_startup_script_request Include a JSON object in the request body with a content type of **application/json**.
    # @return [Array<(GetStartupScript200Response, Integer, Hash)>] GetStartupScript200Response data, response status code and response headers
    def create_startup_script_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: StartupApi.create_startup_script ...'
      end
      # resource path
      local_var_path = '/startup-scripts'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'create_startup_script_request'])

      # return_type
      return_type = opts[:debug_return_type] || 'GetStartupScript200Response'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['API Key']

      new_options = opts.merge(
        :operation => :"StartupApi.create_startup_script",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: StartupApi#create_startup_script\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Delete Startup Script
    # Delete a Startup Script.
    # @param startup_id [String] The [Startup Script id](#operation/list-startup-scripts).
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_startup_script(startup_id, opts = {})
      delete_startup_script_with_http_info(startup_id, opts)
      nil
    end

    # Delete Startup Script
    # Delete a Startup Script.
    # @param startup_id [String] The [Startup Script id](#operation/list-startup-scripts).
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def delete_startup_script_with_http_info(startup_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: StartupApi.delete_startup_script ...'
      end
      # verify the required parameter 'startup_id' is set
      if @api_client.config.client_side_validation && startup_id.nil?
        fail ArgumentError, "Missing the required parameter 'startup_id' when calling StartupApi.delete_startup_script"
      end
      # resource path
      local_var_path = '/startup-scripts/{startup-id}'.sub('{' + 'startup-id' + '}', CGI.escape(startup_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type]

      # auth_names
      auth_names = opts[:debug_auth_names] || ['API Key']

      new_options = opts.merge(
        :operation => :"StartupApi.delete_startup_script",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: StartupApi#delete_startup_script\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get Startup Script
    # Get information for a Startup Script.
    # @param startup_id [String] The [Startup Script id](#operation/list-startup-scripts).
    # @param [Hash] opts the optional parameters
    # @return [GetStartupScript200Response]
    def get_startup_script(startup_id, opts = {})
      data, _status_code, _headers = get_startup_script_with_http_info(startup_id, opts)
      data
    end

    # Get Startup Script
    # Get information for a Startup Script.
    # @param startup_id [String] The [Startup Script id](#operation/list-startup-scripts).
    # @param [Hash] opts the optional parameters
    # @return [Array<(GetStartupScript200Response, Integer, Hash)>] GetStartupScript200Response data, response status code and response headers
    def get_startup_script_with_http_info(startup_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: StartupApi.get_startup_script ...'
      end
      # verify the required parameter 'startup_id' is set
      if @api_client.config.client_side_validation && startup_id.nil?
        fail ArgumentError, "Missing the required parameter 'startup_id' when calling StartupApi.get_startup_script"
      end
      # resource path
      local_var_path = '/startup-scripts/{startup-id}'.sub('{' + 'startup-id' + '}', CGI.escape(startup_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'GetStartupScript200Response'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['API Key']

      new_options = opts.merge(
        :operation => :"StartupApi.get_startup_script",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: StartupApi#get_startup_script\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # List Startup Scripts
    # Get a list of all Startup Scripts.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :per_page Number of items requested per page. Default is 100 and Max is 500.
    # @option opts [String] :cursor Cursor for paging. See [Meta and Pagination](#section/Introduction/Meta-and-Pagination).
    # @return [ListStartupScripts200Response]
    def list_startup_scripts(opts = {})
      data, _status_code, _headers = list_startup_scripts_with_http_info(opts)
      data
    end

    # List Startup Scripts
    # Get a list of all Startup Scripts.
    # @param [Hash] opts the optional parameters
    # @option opts [Integer] :per_page Number of items requested per page. Default is 100 and Max is 500.
    # @option opts [String] :cursor Cursor for paging. See [Meta and Pagination](#section/Introduction/Meta-and-Pagination).
    # @return [Array<(ListStartupScripts200Response, Integer, Hash)>] ListStartupScripts200Response data, response status code and response headers
    def list_startup_scripts_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: StartupApi.list_startup_scripts ...'
      end
      # resource path
      local_var_path = '/startup-scripts'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'per_page'] = opts[:'per_page'] if !opts[:'per_page'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'ListStartupScripts200Response'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['API Key']

      new_options = opts.merge(
        :operation => :"StartupApi.list_startup_scripts",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: StartupApi#list_startup_scripts\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Update Startup Script
    # Update a Startup Script. The attributes `name` and `script` are optional. If not set, the attributes will retain their original values. The `script` attribute is base-64 encoded. New deployments will use the updated script, but this action does not update previously deployed instances.
    # @param startup_id [String] The [Startup Script id](#operation/list-startup-scripts).
    # @param [Hash] opts the optional parameters
    # @option opts [UpdateStartupScriptRequest] :update_startup_script_request Include a JSON object in the request body with a content type of **application/json**.
    # @return [nil]
    def update_startup_script(startup_id, opts = {})
      update_startup_script_with_http_info(startup_id, opts)
      nil
    end

    # Update Startup Script
    # Update a Startup Script. The attributes &#x60;name&#x60; and &#x60;script&#x60; are optional. If not set, the attributes will retain their original values. The &#x60;script&#x60; attribute is base-64 encoded. New deployments will use the updated script, but this action does not update previously deployed instances.
    # @param startup_id [String] The [Startup Script id](#operation/list-startup-scripts).
    # @param [Hash] opts the optional parameters
    # @option opts [UpdateStartupScriptRequest] :update_startup_script_request Include a JSON object in the request body with a content type of **application/json**.
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def update_startup_script_with_http_info(startup_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: StartupApi.update_startup_script ...'
      end
      # verify the required parameter 'startup_id' is set
      if @api_client.config.client_side_validation && startup_id.nil?
        fail ArgumentError, "Missing the required parameter 'startup_id' when calling StartupApi.update_startup_script"
      end
      # resource path
      local_var_path = '/startup-scripts/{startup-id}'.sub('{' + 'startup-id' + '}', CGI.escape(startup_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Content-Type'
      content_type = @api_client.select_header_content_type(['application/json'])
      if !content_type.nil?
          header_params['Content-Type'] = content_type
      end

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'update_startup_script_request'])

      # return_type
      return_type = opts[:debug_return_type]

      # auth_names
      auth_names = opts[:debug_auth_names] || ['API Key']

      new_options = opts.merge(
        :operation => :"StartupApi.update_startup_script",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: StartupApi#update_startup_script\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
