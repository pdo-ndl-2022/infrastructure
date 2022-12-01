module "sql_db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "8.0.0"
  database_version = "POSTGRES_14"
  name = "pgsql"
  project_id = "pdo-ndl-2022"
  zone = "europe-west1-b"
  region = "europe-west1"
}


output "generated_user_password" {
  value = module.sql_db.generated_user_password
  sensitive = true

}

output "db_url" {
  value = module.sql_db.public_ip_address
  sensitive = true
}