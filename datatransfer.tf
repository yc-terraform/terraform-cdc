resource "yandex_datatransfer_endpoint" "postgres_source" {
  name = "${var.userdb}-postgres-source-endpoint"

  settings {
    postgres_source {
      connection {
        mdb_cluster_id = module.db.cluster_id
      }
      database = var.userdb
      user     = var.userdb
      password {
        raw = var.password
      }
    }
  }
}
resource "yandex_datatransfer_endpoint" "kafka_source" {
  name = "${var.userdb}-kafka-source-endpoint"

  settings {
    kafka_source {
      connection {
        cluster_id = yandex_mdb_kafka_cluster.cdc.id
      }
      auth {
        sasl {
          mechanism = "KAFKA_MECHANISM_SHA512"
          user      = var.userdb
          password {
            raw = var.password
          }
        }
      }
     topic_names = [var.userdb]


      parser {
        json_parser {
          data_schema {
            json_fields = jsonencode([
              {
                name = "id"
                type = "uint32"
                key  = true
              },
              {
                name = "name"
                type = "utf8"
              },
              {
                name = "description"
                type = "utf8"
              }
            ])
          }
          null_keys_allowed       = true
          add_rest_column         = true
          unescape_string_values  = true
        }
      }
    }
  }
}




resource "yandex_datatransfer_endpoint" "kafka_target" {
  name = "${var.userdb}-kafka-target-endpoint"

  settings {
    kafka_target {
      connection {
        cluster_id = yandex_mdb_kafka_cluster.cdc.id
      }
      auth {
        sasl {
          mechanism = "KAFKA_MECHANISM_SHA512"
          user      = var.userdb
          password {
            raw = var.password
          }
        }
      }
      topic_settings {
        topic {
            topic_name ="${var.userdb}"
        }
      }
      serializer {
      serializer_auto {}
      }
  }
}
}

resource "yandex_datatransfer_endpoint" "clickhouse_target" {
  name = "${var.userdb}-clickhouse-target-endpoint"

  settings {
    clickhouse_target {
      connection {
        connection_options {       
            mdb_cluster_id = yandex_mdb_clickhouse_cluster.cdc.id
            user           = var.userdb
            database       = var.userdb
                  
            password {
                raw = var.password
             }
        }

      }
    }
  }


}