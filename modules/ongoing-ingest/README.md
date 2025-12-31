## On-going Ingest

This module subscribes an SQS ingest queue to an SNS topic that broadcasts new data in a source STAC catalog

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_collections_list"></a> [destination\_collections\_list](#input\_destination\_collections\_list) | The (comma-separated) list of collections to ingest | `string` | n/a | yes |
| <a name="input_destination_collections_max_lat"></a> [destination\_collections\_max\_lat](#input\_destination\_collections\_max\_lat) | The maximum latitude of the bounding box area | `number` | n/a | yes |
| <a name="input_destination_collections_max_long"></a> [destination\_collections\_max\_long](#input\_destination\_collections\_max\_long) | The maximum longitude of the bounding box area | `number` | n/a | yes |
| <a name="input_destination_collections_min_lat"></a> [destination\_collections\_min\_lat](#input\_destination\_collections\_min\_lat) | The minimum latitude of the bounding box area | `number` | n/a | yes |
| <a name="input_destination_collections_min_long"></a> [destination\_collections\_min\_long](#input\_destination\_collections\_min\_long) | The minimum longitude of the bounding box area | `number` | n/a | yes |
| <a name="input_ingest_sqs_arn"></a> [ingest\_sqs\_arn](#input\_ingest\_sqs\_arn) | The ARN of the SQS topic that we want to publish ingest messages to | `string` | n/a | yes |
| <a name="input_source_sns_arn"></a> [source\_sns\_arn](#input\_source\_sns\_arn) | The ARN of the SNS topic that we want to receive updates from | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
