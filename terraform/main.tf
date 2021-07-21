provider "google" {
  project     = var.project_id
  region      = var.region
}

# Enable APIs
resource "google_project_services" "project" {
  project   = var.project_id
  services  = ["iam.googleapis.com", 
                "cloudresourcemanager.googleapis.com",
                "pubsub.googleapis.com",
                "dataflow.googleapis.com",
                "bigtable.googleapis.com",
                "bigtableadmin.googleapis.com",
                "bigtabletableadmin.googleapis.com",
                "bigquery.googleapis.com"
            ]
}

module "bigquery" {
    source  = "terraform-google-modules/bigquery/google"
    version = "5.2.0"
    
    dataset_id                  = "taxi_rides"
    dataset_name                = "taxi_rides"
    description                 = "Taxi Rides"
    delete_contents_on_destroy  = true
    project_id                  = var.project_id
    location                    = "US"

    tables = [
        {
            table_id = "dollars_per_minute",
            schema = "./schema/dollars_per_minute.json",
            time_partitioning = null,
            range_partitioning = null
        },
        {
            table_id = "rides_in_lower_manhatten",
            schema = "./schema/rides_in_lower_manhatten.json",
            time_partitioning = null,
            range_partitioning = null
        }

    ]
}

resource "google_bigtable_instance" "taxi-rides" {
    name = "taxi-rides"

    cluster {
        cluster_id = "taxi-rides-cluster"
        num_nodes = 1
        storage_type = "HDD"
    }
}

resource "google_bigtable_table" "taxi-rides" {
    name = "taxi-rides"
    instance_name = google_bigtable_instance.taxi-rides.name
}