

variable "yc_zone" {
  type        = string
  description = "Yandex Cloud compute default zone"
  default     = "ru-central1-a"
}

variable "userdb" {
  type        = string
  description = "User name, topic, database"
  default     = "cdc"
}

variable "password" {
  type        = string
  description = "Password for Kafka/PosgtreSQL"
  default     = "in9Uz8ahkoo7zi8oGuDuz1kai7someiD"
}