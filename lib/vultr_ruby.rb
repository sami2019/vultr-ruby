=begin
#Vultr API

## Introduction  The Vultr API v2 is a set of HTTP endpoints that adhere to RESTful design principles and CRUD actions with predictable URIs. It uses standard HTTP response codes, authentication, and verbs. The API has consistent and well-formed JSON requests and responses with cursor-based pagination to simplify list handling. Error messages are descriptive and easy to understand. All functions of the Vultr customer portal are accessible via the API, enabling you to script complex unattended scenarios with any tool fluent in HTTP.  ## Requests  Communicate with the API by making an HTTP request at the correct endpoint. The chosen method determines the action taken.  | Method | Usage | | ------ | ------------- | | DELETE | Use the DELETE method to destroy a resource in your account. If it is not found, the operation will return a 4xx error and an appropriate message. | | GET | To retrieve information about a resource, use the GET method. The data is returned as a JSON object. GET methods are read-only and do not affect any resources. | | PATCH | Some resources support partial modification with PATCH, which modifies specific attributes without updating the entire object representation. | | POST | Issue a POST method to create a new object. Include all needed attributes in the request body encoded as JSON. | | PUT | Use the PUT method to update information about a resource. PUT will set new values on the item without regard to their current values. |  **Rate Limit:** Vultr safeguards the API against bursts of incoming traffic based on the request's IP address to ensure stability for all users. If your application sends more than 30 requests per second, the API may return HTTP status code 429.  ## Response Codes  We use standard HTTP response codes to show the success or failure of requests. Response codes in the 2xx range indicate success, while codes in the 4xx range indicate an error, such as an authorization failure or a malformed request. All 4xx errors will return a JSON response object with an `error` attribute explaining the error. Codes in the 5xx range indicate a server-side problem preventing Vultr from fulfilling your request.  | Response | Description | | ------ | ------------- | | 200 OK | The response contains your requested information. | | 201 Created | Your request was accepted. The resource was created. | | 202 Accepted | Your request was accepted. The resource was created or updated. | | 204 No Content | Your request succeeded, there is no additional information returned. | | 400 Bad Request | Your request was malformed. | | 401 Unauthorized | You did not supply valid authentication credentials. | | 403 Forbidden | You are not allowed to perform that action. | | 404 Not Found | No results were found for your request. | | 429 Too Many Requests | Your request exceeded the API rate limit. | | 500 Internal Server Error | We were unable to perform the request due to server-side problems. |  ## Meta and Pagination  Many API calls will return a `meta` object with paging information.  ### Definitions  | Term | Description | | ------ | ------------- | | **List** | The items returned from the database for your request (not necessarily shown in a single response depending on the **cursor** size). | | **Page** | A subset of the full **list** of items. Choose the size of a **page** with the `per_page` parameter. | | **Total** | The `total` attribute indicates the number of items in the full **list**.| | **Cursor** | Use the `cursor` query parameter to select a next or previous **page**. | | **Next** & **Prev** | Use the `next` and `prev` attributes of the `links` meta object as `cursor` values. |  ### How to use Paging  If your result **list** total exceeds the default **cursor** size (the default depends on the route, but is usually 100 records) or the value defined by the `per_page` query param (when present) the response will be returned to you paginated.  ### Paging Example  > These examples have abbreviated attributes and sample values. Your actual `cursor` values will be encoded alphanumeric strings.  To return a **page** with the first two plans in the List:      curl \"https://api.vultr.com/v2/plans?per_page=2\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  The API returns an object similar to this:      {         \"plans\": [             {                 \"id\": \"vc2-1c-2gb\",                 \"vcpu_count\": 1,                 \"ram\": 2048,                 \"locations\": []             },             {                 \"id\": \"vc2-24c-97gb\",                 \"vcpu_count\": 24,                 \"ram\": 98304,                 \"locations\": []             }         ],         \"meta\": {             \"total\": 19,             \"links\": {                 \"next\": \"WxYzExampleNext\",                 \"prev\": \"WxYzExamplePrev\"             }         }     }  The object contains two plans. The `total` attribute indicates that 19 plans are available in the List. To navigate forward in the **list**, use the `next` value (`WxYzExampleNext` in this example) as your `cursor` query parameter.      curl \"https://api.vultr.com/v2/plans?per_page=2&cursor=WxYzExampleNext\" \\       -X GET       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  Likewise, you can use the example `prev` value `WxYzExamplePrev` to navigate backward.  ## Parameters  You can pass information to the API with three different types of parameters.  ### Path parameters  Some API calls require variable parameters as part of the endpoint path. For example, to retrieve information about a user, supply the `user-id` in the endpoint.      curl \"https://api.vultr.com/v2/users/{user-id}\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  ### Query parameters  Some API calls allow filtering with query parameters. For example, the `/v2/plans` endpoint supports a `type` query parameter. Setting `type=vhf` instructs the API only to return High Frequency Compute plans in the list. You'll find more specifics about valid filters in the endpoint documentation below.      curl \"https://api.vultr.com/v2/plans?type=vhf\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  You can also combine filtering with paging. Use the `per_page` parameter to retreive a subset of vhf plans.      curl \"https://api.vultr.com/v2/plans?type=vhf&per_page=2\" \\       -X GET \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\"  ### Request Body  PUT, POST, and PATCH methods may include an object in the request body with a content type of **application/json**. The documentation for each endpoint below has more information about the expected object.  ## API Example Conventions  The examples in this documentation use `curl`, a command-line HTTP client, to demonstrate useage. Linux and macOS computers usually have curl installed by default, and it's [available for download](https://curl.se/download.html) on all popular platforms including Windows.  Each example is split across multiple lines with the `\\` character, which is compatible with a `bash` terminal. A typical example looks like this:      curl \"https://api.vultr.com/v2/domains\" \\       -X POST \\       -H \"Authorization: Bearer ${VULTR_API_KEY}\" \\       -H \"Content-Type: application/json\" \\       --data '{         \"domain\" : \"example.com\",         \"ip\" : \"192.0.2.123\"       }'  * The `-X` parameter sets the request method. For consistency, we show the method on all examples, even though it's not explicitly required for GET methods. * The `-H` lines set required HTTP headers. These examples are formatted to expand the VULTR\\_API\\_KEY environment variable for your convenience. * Examples that require a JSON object in the request body pass the required data via the `--data` parameter.  All values in this guide are examples. Do not rely on the OS or Plan IDs listed in this guide; use the appropriate endpoint to retreive values before creating resources. 

The version of the OpenAPI document: 2.0
Contact: support@vultr.com
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 7.2.0-SNAPSHOT

=end

# Common files
require 'vultr_ruby/api_client'
require 'vultr_ruby/api_error'
require 'vultr_ruby/version'
require 'vultr_ruby/configuration'

# Models
require 'vultr_ruby/models/account'
require 'vultr_ruby/models/application'
require 'vultr_ruby/models/attach_baremetals_vpc2_request'
require 'vultr_ruby/models/attach_block_request'
require 'vultr_ruby/models/attach_instance_iso202_response'
require 'vultr_ruby/models/attach_instance_iso202_response_iso_status'
require 'vultr_ruby/models/attach_instance_iso_request'
require 'vultr_ruby/models/attach_instance_network_request'
require 'vultr_ruby/models/attach_instance_vpc2_request'
require 'vultr_ruby/models/attach_instance_vpc_request'
require 'vultr_ruby/models/attach_reserved_ip_request'
require 'vultr_ruby/models/attach_vpc2_nodes_request'
require 'vultr_ruby/models/backup'
require 'vultr_ruby/models/backup_schedule'
require 'vultr_ruby/models/bandwidth'
require 'vultr_ruby/models/baremetal'
require 'vultr_ruby/models/baremetal_ipv4'
require 'vultr_ruby/models/baremetal_ipv6'
require 'vultr_ruby/models/billing'
require 'vultr_ruby/models/blockstorage'
require 'vultr_ruby/models/clusters'
require 'vultr_ruby/models/connection_pool'
require 'vultr_ruby/models/convert_reserved_ip_request'
require 'vultr_ruby/models/create_baremetal202_response'
require 'vultr_ruby/models/create_baremetal_request'
require 'vultr_ruby/models/create_block202_response'
require 'vultr_ruby/models/create_block_request'
require 'vultr_ruby/models/create_connection_pool202_response'
require 'vultr_ruby/models/create_connection_pool_request'
require 'vultr_ruby/models/create_database202_response'
require 'vultr_ruby/models/create_database_db202_response'
require 'vultr_ruby/models/create_database_db_request'
require 'vultr_ruby/models/create_database_request'
require 'vultr_ruby/models/create_database_user202_response'
require 'vultr_ruby/models/create_database_user_request'
require 'vultr_ruby/models/create_dns_domain200_response'
require 'vultr_ruby/models/create_dns_domain_record201_response'
require 'vultr_ruby/models/create_dns_domain_record_request'
require 'vultr_ruby/models/create_dns_domain_request'
require 'vultr_ruby/models/create_firewall_group201_response'
require 'vultr_ruby/models/create_firewall_group_request'
require 'vultr_ruby/models/create_instance202_response'
require 'vultr_ruby/models/create_instance_backup_schedule_request'
require 'vultr_ruby/models/create_instance_ipv4_request'
require 'vultr_ruby/models/create_instance_request'
require 'vultr_ruby/models/create_instance_reverse_ipv4_request'
require 'vultr_ruby/models/create_instance_reverse_ipv6_request'
require 'vultr_ruby/models/create_iso201_response'
require 'vultr_ruby/models/create_iso_request'
require 'vultr_ruby/models/create_kubernetes_cluster201_response'
require 'vultr_ruby/models/create_kubernetes_cluster_request'
require 'vultr_ruby/models/create_kubernetes_cluster_request_node_pools_inner'
require 'vultr_ruby/models/create_load_balancer202_response'
require 'vultr_ruby/models/create_load_balancer_forwarding_rules_request'
require 'vultr_ruby/models/create_load_balancer_request'
require 'vultr_ruby/models/create_load_balancer_request_firewall_rules_inner'
require 'vultr_ruby/models/create_load_balancer_request_forwarding_rules_inner'
require 'vultr_ruby/models/create_load_balancer_request_health_check'
require 'vultr_ruby/models/create_load_balancer_request_ssl'
require 'vultr_ruby/models/create_load_balancer_request_sticky_session'
require 'vultr_ruby/models/create_network_request'
require 'vultr_ruby/models/create_nodepools201_response'
require 'vultr_ruby/models/create_nodepools_request'
require 'vultr_ruby/models/create_object_storage202_response'
require 'vultr_ruby/models/create_object_storage_request'
require 'vultr_ruby/models/create_registry_request'
require 'vultr_ruby/models/create_reserved_ip_request'
require 'vultr_ruby/models/create_snapshot_create_from_url_request'
require 'vultr_ruby/models/create_snapshot_request'
require 'vultr_ruby/models/create_ssh_key_request'
require 'vultr_ruby/models/create_startup_script_request'
require 'vultr_ruby/models/create_subaccount201_response'
require 'vultr_ruby/models/create_subaccount_request'
require 'vultr_ruby/models/create_user_request'
require 'vultr_ruby/models/create_vpc2_request'
require 'vultr_ruby/models/create_vpc_request'
require 'vultr_ruby/models/database'
require 'vultr_ruby/models/database_add_read_replica_request'
require 'vultr_ruby/models/database_connections'
require 'vultr_ruby/models/database_db'
require 'vultr_ruby/models/database_ferretdb_credentials'
require 'vultr_ruby/models/database_fork_request'
require 'vultr_ruby/models/database_latest_backup'
require 'vultr_ruby/models/database_oldest_backup'
require 'vultr_ruby/models/database_restore_from_backup_request'
require 'vultr_ruby/models/database_start_migration_request'
require 'vultr_ruby/models/database_usage'
require 'vultr_ruby/models/database_usage_cpu'
require 'vultr_ruby/models/database_usage_disk'
require 'vultr_ruby/models/database_usage_memory'
require 'vultr_ruby/models/database_user'
require 'vultr_ruby/models/database_user_access_control'
require 'vultr_ruby/models/dbaas_alerts'
require 'vultr_ruby/models/dbaas_available_options'
require 'vultr_ruby/models/dbaas_meta'
require 'vultr_ruby/models/dbaas_migration'
require 'vultr_ruby/models/dbaas_migration_credentials'
require 'vultr_ruby/models/dbaas_plan'
require 'vultr_ruby/models/detach_baremetal_vpc2_request'
require 'vultr_ruby/models/detach_block_request'
require 'vultr_ruby/models/detach_instance_iso202_response'
require 'vultr_ruby/models/detach_instance_iso202_response_iso_status'
require 'vultr_ruby/models/detach_instance_network_request'
require 'vultr_ruby/models/detach_instance_vpc2_request'
require 'vultr_ruby/models/detach_instance_vpc_request'
require 'vultr_ruby/models/detach_vpc2_nodes_request'
require 'vultr_ruby/models/dns_record'
require 'vultr_ruby/models/dns_soa'
require 'vultr_ruby/models/domain'
require 'vultr_ruby/models/firewall_group'
require 'vultr_ruby/models/firewall_rule'
require 'vultr_ruby/models/forwarding_rule'
require 'vultr_ruby/models/get_account200_response'
require 'vultr_ruby/models/get_backup200_response'
require 'vultr_ruby/models/get_backup_information200_response'
require 'vultr_ruby/models/get_bandwidth_baremetal200_response'
require 'vultr_ruby/models/get_bandwidth_baremetal200_response_bandwidth'
require 'vultr_ruby/models/get_bare_metal_userdata200_response'
require 'vultr_ruby/models/get_bare_metal_userdata200_response_user_data'
require 'vultr_ruby/models/get_bare_metal_vnc200_response'
require 'vultr_ruby/models/get_bare_metal_vnc200_response_vnc'
require 'vultr_ruby/models/get_bare_metals_upgrades200_response'
require 'vultr_ruby/models/get_bare_metals_upgrades200_response_upgrades'
require 'vultr_ruby/models/get_baremetal200_response'
require 'vultr_ruby/models/get_database_usage200_response'
require 'vultr_ruby/models/get_dns_domain_dnssec200_response'
require 'vultr_ruby/models/get_dns_domain_soa200_response'
require 'vultr_ruby/models/get_instance_backup_schedule200_response'
require 'vultr_ruby/models/get_instance_iso_status200_response'
require 'vultr_ruby/models/get_instance_iso_status200_response_iso_status'
require 'vultr_ruby/models/get_instance_neighbors200_response'
require 'vultr_ruby/models/get_instance_upgrades200_response'
require 'vultr_ruby/models/get_instance_upgrades200_response_upgrades'
require 'vultr_ruby/models/get_instance_userdata200_response'
require 'vultr_ruby/models/get_instance_userdata200_response_user_data'
require 'vultr_ruby/models/get_invoice200_response'
require 'vultr_ruby/models/get_invoice_items200_response'
require 'vultr_ruby/models/get_invoice_items200_response_invoice_items_inner'
require 'vultr_ruby/models/get_invoice_items200_response_meta'
require 'vultr_ruby/models/get_invoice_items200_response_meta_links'
require 'vultr_ruby/models/get_ipv4_baremetal200_response'
require 'vultr_ruby/models/get_ipv6_baremetal200_response'
require 'vultr_ruby/models/get_kubernetes_available_upgrades200_response'
require 'vultr_ruby/models/get_kubernetes_clusters_config200_response'
require 'vultr_ruby/models/get_kubernetes_resources200_response'
require 'vultr_ruby/models/get_kubernetes_resources200_response_resources'
require 'vultr_ruby/models/get_kubernetes_resources200_response_resources_block_storage_inner'
require 'vultr_ruby/models/get_kubernetes_resources200_response_resources_load_balancer_inner'
require 'vultr_ruby/models/get_kubernetes_versions200_response'
require 'vultr_ruby/models/get_load_balancer_forwarding_rule200_response'
require 'vultr_ruby/models/get_network200_response'
require 'vultr_ruby/models/get_nodepools200_response'
require 'vultr_ruby/models/get_reserved_ip200_response'
require 'vultr_ruby/models/get_snapshot200_response'
require 'vultr_ruby/models/get_ssh_key200_response'
require 'vultr_ruby/models/get_startup_script200_response'
require 'vultr_ruby/models/get_vpc200_response'
require 'vultr_ruby/models/get_vpc2200_response'
require 'vultr_ruby/models/halt_baremetals_request'
require 'vultr_ruby/models/halt_instances_request'
require 'vultr_ruby/models/instance'
require 'vultr_ruby/models/instance_v6_networks_inner'
require 'vultr_ruby/models/instance_vpc2'
require 'vultr_ruby/models/invoice'
require 'vultr_ruby/models/iso'
require 'vultr_ruby/models/iso_public'
require 'vultr_ruby/models/list_advanced_options200_response'
require 'vultr_ruby/models/list_applications200_response'
require 'vultr_ruby/models/list_available_plans_region200_response'
require 'vultr_ruby/models/list_available_versions200_response'
require 'vultr_ruby/models/list_backups200_response'
require 'vultr_ruby/models/list_baremetal_vpc2200_response'
require 'vultr_ruby/models/list_baremetals200_response'
require 'vultr_ruby/models/list_billing_history200_response'
require 'vultr_ruby/models/list_blocks200_response'
require 'vultr_ruby/models/list_connection_pools200_response'
require 'vultr_ruby/models/list_database_dbs200_response'
require 'vultr_ruby/models/list_database_plans200_response'
require 'vultr_ruby/models/list_database_users200_response'
require 'vultr_ruby/models/list_databases200_response'
require 'vultr_ruby/models/list_dns_domain_records200_response'
require 'vultr_ruby/models/list_dns_domains200_response'
require 'vultr_ruby/models/list_firewall_group_rules200_response'
require 'vultr_ruby/models/list_firewall_groups200_response'
require 'vultr_ruby/models/list_instance_ipv6_reverse200_response'
require 'vultr_ruby/models/list_instance_ipv6_reverse200_response_reverse_ipv6s_inner'
require 'vultr_ruby/models/list_instance_private_networks200_response'
require 'vultr_ruby/models/list_instance_vpc2200_response'
require 'vultr_ruby/models/list_instance_vpcs200_response'
require 'vultr_ruby/models/list_instances200_response'
require 'vultr_ruby/models/list_invoices200_response'
require 'vultr_ruby/models/list_isos200_response'
require 'vultr_ruby/models/list_kubernetes_clusters200_response'
require 'vultr_ruby/models/list_load_balancer_forwarding_rules200_response'
require 'vultr_ruby/models/list_load_balancers200_response'
require 'vultr_ruby/models/list_maintenance_updates200_response'
require 'vultr_ruby/models/list_metal_plans200_response'
require 'vultr_ruby/models/list_networks200_response'
require 'vultr_ruby/models/list_object_storage_clusters200_response'
require 'vultr_ruby/models/list_object_storages200_response'
require 'vultr_ruby/models/list_os200_response'
require 'vultr_ruby/models/list_plans200_response'
require 'vultr_ruby/models/list_public_isos200_response'
require 'vultr_ruby/models/list_regions200_response'
require 'vultr_ruby/models/list_registries200_response'
require 'vultr_ruby/models/list_registry_plans200_response'
require 'vultr_ruby/models/list_registry_plans200_response_plans'
require 'vultr_ruby/models/list_registry_regions200_response'
require 'vultr_ruby/models/list_registry_repositories200_response'
require 'vultr_ruby/models/list_reserved_ips200_response'
require 'vultr_ruby/models/list_service_alerts200_response'
require 'vultr_ruby/models/list_service_alerts_request'
require 'vultr_ruby/models/list_snapshots200_response'
require 'vultr_ruby/models/list_ssh_keys200_response'
require 'vultr_ruby/models/list_startup_scripts200_response'
require 'vultr_ruby/models/list_subaccounts200_response'
require 'vultr_ruby/models/list_users200_response'
require 'vultr_ruby/models/list_vpc2200_response'
require 'vultr_ruby/models/list_vpcs200_response'
require 'vultr_ruby/models/loadbalancer'
require 'vultr_ruby/models/loadbalancer_firewall_rule'
require 'vultr_ruby/models/loadbalancer_firewall_rules_inner'
require 'vultr_ruby/models/loadbalancer_forward_rules_inner'
require 'vultr_ruby/models/loadbalancer_generic_info'
require 'vultr_ruby/models/loadbalancer_generic_info_sticky_sessions'
require 'vultr_ruby/models/loadbalancer_health_check'
require 'vultr_ruby/models/meta'
require 'vultr_ruby/models/meta_links'
require 'vultr_ruby/models/network'
require 'vultr_ruby/models/nodepool_instances'
require 'vultr_ruby/models/nodepools'
require 'vultr_ruby/models/object_storage'
require 'vultr_ruby/models/os'
require 'vultr_ruby/models/patch_reserved_ips_reserved_ip_request'
require 'vultr_ruby/models/plans'
require 'vultr_ruby/models/plans_metal'
require 'vultr_ruby/models/post_firewalls_firewall_group_id_rules201_response'
require 'vultr_ruby/models/post_firewalls_firewall_group_id_rules_request'
require 'vultr_ruby/models/post_instances_instance_id_ipv4_reverse_default_request'
require 'vultr_ruby/models/private_networks'
require 'vultr_ruby/models/put_snapshots_snapshot_id_request'
require 'vultr_ruby/models/reboot_instances_request'
require 'vultr_ruby/models/regenerate_object_storage_keys201_response'
require 'vultr_ruby/models/regenerate_object_storage_keys201_response_s3_credentials'
require 'vultr_ruby/models/region'
require 'vultr_ruby/models/registry'
require 'vultr_ruby/models/registry_docker_credentials'
require 'vultr_ruby/models/registry_docker_credentials_auths'
require 'vultr_ruby/models/registry_docker_credentials_auths_registry_region_name_vultrcr_com'
require 'vultr_ruby/models/registry_kubernetes_docker_credentials'
require 'vultr_ruby/models/registry_kubernetes_docker_credentials_data'
require 'vultr_ruby/models/registry_kubernetes_docker_credentials_metadata'
require 'vultr_ruby/models/registry_metadata'
require 'vultr_ruby/models/registry_metadata_subscription'
require 'vultr_ruby/models/registry_metadata_subscription_billing'
require 'vultr_ruby/models/registry_plan'
require 'vultr_ruby/models/registry_region'
require 'vultr_ruby/models/registry_repository'
require 'vultr_ruby/models/registry_storage'
require 'vultr_ruby/models/registry_user'
require 'vultr_ruby/models/reinstall_baremetal_request'
require 'vultr_ruby/models/reinstall_instance_request'
require 'vultr_ruby/models/reserved_ip'
require 'vultr_ruby/models/restore_instance202_response'
require 'vultr_ruby/models/restore_instance202_response_status'
require 'vultr_ruby/models/restore_instance_request'
require 'vultr_ruby/models/set_database_user_acl_request'
require 'vultr_ruby/models/snapshot'
require 'vultr_ruby/models/ssh'
require 'vultr_ruby/models/start_instances_request'
require 'vultr_ruby/models/start_kubernetes_cluster_upgrade_request'
require 'vultr_ruby/models/start_maintenance_updates200_response'
require 'vultr_ruby/models/start_version_upgrade200_response'
require 'vultr_ruby/models/start_version_upgrade_request'
require 'vultr_ruby/models/startup'
require 'vultr_ruby/models/subaccount'
require 'vultr_ruby/models/update_advanced_options_request'
require 'vultr_ruby/models/update_baremetal_request'
require 'vultr_ruby/models/update_block_request'
require 'vultr_ruby/models/update_connection_pool_request'
require 'vultr_ruby/models/update_database_request'
require 'vultr_ruby/models/update_database_user_request'
require 'vultr_ruby/models/update_dns_domain_record_request'
require 'vultr_ruby/models/update_dns_domain_request'
require 'vultr_ruby/models/update_dns_domain_soa_request'
require 'vultr_ruby/models/update_firewall_group_request'
require 'vultr_ruby/models/update_instance_request'
require 'vultr_ruby/models/update_kubernetes_cluster_request'
require 'vultr_ruby/models/update_load_balancer_request'
require 'vultr_ruby/models/update_load_balancer_request_health_check'
require 'vultr_ruby/models/update_network_request'
require 'vultr_ruby/models/update_nodepool_request'
require 'vultr_ruby/models/update_nodepool_request1'
require 'vultr_ruby/models/update_object_storage_request'
require 'vultr_ruby/models/update_registry_request'
require 'vultr_ruby/models/update_repository_request'
require 'vultr_ruby/models/update_ssh_key_request'
require 'vultr_ruby/models/update_startup_script_request'
require 'vultr_ruby/models/update_user_request'
require 'vultr_ruby/models/update_vpc2_request'
require 'vultr_ruby/models/update_vpc_request'
require 'vultr_ruby/models/user'
require 'vultr_ruby/models/user_user'
require 'vultr_ruby/models/view_migration_status200_response'
require 'vultr_ruby/models/vke_cluster'
require 'vultr_ruby/models/vpc'
require 'vultr_ruby/models/vpc2'

# APIs
require 'vultr_ruby/api/account_api'
require 'vultr_ruby/api/application_api'
require 'vultr_ruby/api/backup_api'
require 'vultr_ruby/api/baremetal_api'
require 'vultr_ruby/api/billing_api'
require 'vultr_ruby/api/block_api'
require 'vultr_ruby/api/container_registry_api'
require 'vultr_ruby/api/dns_api'
require 'vultr_ruby/api/firewall_api'
require 'vultr_ruby/api/instances_api'
require 'vultr_ruby/api/iso_api'
require 'vultr_ruby/api/kubernetes_api'
require 'vultr_ruby/api/load_balancer_api'
require 'vultr_ruby/api/managed_databases_api'
require 'vultr_ruby/api/os_api'
require 'vultr_ruby/api/plans_api'
require 'vultr_ruby/api/private_networks_api'
require 'vultr_ruby/api/region_api'
require 'vultr_ruby/api/reserved_ip_api'
require 'vultr_ruby/api/s3_api'
require 'vultr_ruby/api/snapshot_api'
require 'vultr_ruby/api/ssh_api'
require 'vultr_ruby/api/startup_api'
require 'vultr_ruby/api/subaccount_api'
require 'vultr_ruby/api/users_api'
require 'vultr_ruby/api/vpc2_api'
require 'vultr_ruby/api/vpcs_api'

module VultrRuby
  class << self
    # Customize default settings for the SDK using block.
    #   VultrRuby.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end
