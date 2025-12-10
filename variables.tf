variable "db_name" {
  description = "Nom de la base de données PostgreSQL."
  type        = string
  default     = "rt5_db"
}
variable "db_user" {
  description = "Nom d'utilisateur PostgreSQL."
  type        = string
  default     = "rt5_user"
}
variable "db_password" {
  description = "Mot de passe PostgreSQL"
  type        = string
  default     = "RT5-DevOpsv2"
}
variable "app_port_external" {
  description = "Port externe pour accéder à l'application web"
  type        = number
  default     = 8080
}
