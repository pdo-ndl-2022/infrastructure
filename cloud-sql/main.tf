locals {
  databases = [
    "strapi"
  ]
}

resource "random_password" "password" {
  for_each = toset(local.databases)
  special  = false
  length   = 64
}

resource "google_sql_database_instance" "production" {
  name             = "production"
  database_version = "POSTGRES_14"
  region           = "europe-west1"
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  for_each = toset(local.databases)
  instance = google_sql_database_instance.production.id
  name     = each.key
}

resource "google_sql_user" "database" {
  for_each = toset(local.databases)
  instance = google_sql_database_instance.production.id
  name     = each.key
  password = random_password.password[each.key].result
}

output "users" {
  sensitive = true
  value     = { for db in local.databases : db => google_sql_user.database[db].password }
}

output "root_password" {
  sensitive = true
  value     = google_sql_database_instance.production.root_password
}
