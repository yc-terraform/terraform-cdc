resource "yandex_mdb_kafka_cluster" "cdc" {
  name        = var.userdb
  environment = "PRODUCTION"
  network_id  = "${yandex_vpc_network.vpc.id}"
  subnet_ids  = ["${yandex_vpc_subnet.sub_a.id}"]
  security_group_ids = [yandex_vpc_security_group.db_sg.id]
  config {
    version          = "2.8"
    brokers_count    = 1
    zones            = [var.yc_zone]
    assign_public_ip = true
    schema_registry  = false
    kafka {
      resources {
        resource_preset_id = "s2.micro"
        disk_type_id       = "network-ssd"
        disk_size          = 32
      }
      kafka_config {
        compression_type                = "COMPRESSION_TYPE_ZSTD"
      }
    }
  }

  user {
    name     = var.userdb
    password = var.password
    permission {
      topic_name = var.userdb
      role = "ACCESS_ROLE_PRODUCER"
    }
    permission {
      topic_name = var.userdb
      role = "ACCESS_ROLE_CONSUMER"
    }
  }

}
resource "yandex_mdb_kafka_topic" cdd {
  cluster_id         = yandex_mdb_kafka_cluster.cdc.id
  name               = var.userdb
  partitions         = 4
  replication_factor = 1

}