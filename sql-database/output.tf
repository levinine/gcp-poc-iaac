output "sql-instance-name" {
  value = data.google_sql_database_instance.db-instance-data.name
}

output "database-url" {
  value = "jdbc:mysql://${data.google_sql_database_instance.db-instance-data.dns_name}:3306/${google_sql_database.db.name}"
}

output "application-username" {
  value = google_sql_user.application-user.name
}

output "application-password" {
  value = google_sql_user.application-user.password
}