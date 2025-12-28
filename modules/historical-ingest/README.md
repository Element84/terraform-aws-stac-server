## Historical Ingest

This module creates new collections in a new/destination STAC catalog, then queries for data and siphons it from a source STAC catalog, queueing it for ingest into the destination STAC catalog (by way of the SQS ingest queue).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_date_end"></a> [date\_end](#input\_date\_end) | The end date for the historical ingest | `string` | n/a | yes |
| <a name="input_date_start"></a> [date\_start](#input\_date\_start) | The start date for the historical ingest | `string` | n/a | yes |
| <a name="input_destination_catalog_url"></a> [destination\_catalog\_url](#input\_destination\_catalog\_url) | The URL of the destination STAC catalog API | `string` | n/a | yes |
| <a name="input_destination_collections_list"></a> [destination\_collections\_list](#input\_destination\_collections\_list) | The (comma-separated) list of collections to ingest | `string` | n/a | yes |
| <a name="input_destination_collections_max_lat"></a> [destination\_collections\_max\_lat](#input\_destination\_collections\_max\_lat) | The maximum latitude of the bounding box area | `string` | n/a | yes |
| <a name="input_destination_collections_max_long"></a> [destination\_collections\_max\_long](#input\_destination\_collections\_max\_long) | The maximum longitude of the bounding box area | `string` | n/a | yes |
| <a name="input_destination_collections_min_lat"></a> [destination\_collections\_min\_lat](#input\_destination\_collections\_min\_lat) | The minimum latitude of the bounding box area | `string` | n/a | yes |
| <a name="input_destination_collections_min_long"></a> [destination\_collections\_min\_long](#input\_destination\_collections\_min\_long) | The minimum longitude of the bounding box area | `string` | n/a | yes |
| <a name="input_include_historical_ingest"></a> [include\_historical\_ingest](#input\_include\_historical\_ingest) | A true/false value for whether or not to perform historical ingest | `bool` | n/a | yes |
| <a name="input_ingest_sqs_url"></a> [ingest\_sqs\_url](#input\_ingest\_sqs\_url) | The URL of the SQS topic that we want to publish ingest messages to | `string` | n/a | yes |
| <a name="input_source_catalog_url"></a> [source\_catalog\_url](#input\_source\_catalog\_url) | The URL of the source STAC catalog API | `string` | n/a | yes |
| <a name="input_stac_server_lambda_iam_role_arn"></a> [stac\_server\_lambda\_iam\_role\_arn](#input\_stac\_server\_lambda\_iam\_role\_arn) | The parent stac-server IAM role with access to opensearch | `string` | n/a | yes |
| <a name="input_stac_server_name_prefix"></a> [stac\_server\_name\_prefix](#input\_stac\_server\_name\_prefix) | The parent stac-server name prefix for aws resources | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
