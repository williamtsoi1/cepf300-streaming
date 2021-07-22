provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone  
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
            schema = file("${path.module}/schema/dollars_per_minute.json"),
            time_partitioning = null,
            range_partitioning = null,
            clustering = [],
            expiration_time = null,
            labels = null,
        },
        {
            table_id = "rides_in_lower_manhatten",
            schema = file("${path.module}/schema/rides_in_lower_manhatten.json"),
            time_partitioning = null,
            range_partitioning = null,
            clustering = [],
            expiration_time = null,
            labels = null,
        }
    ]
}

resource "google_bigtable_instance" "taxi-rides" {
    name = "taxi-rides"
    deletion_protection = false
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