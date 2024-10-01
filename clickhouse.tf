resource "yandex_mdb_clickhouse_cluster" "cdc" {
  name        = var.userdb
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.vpc.id

  clickhouse {
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 32
    }
  }
  database {
    name = var.userdb
  }
  user {
    name     = var.userdb
    password = var.password
    permission {
      database_name = var.userdb
    }
  }
 host {
    type      = "CLICKHOUSE"
    zone      = var.yc_zone
    subnet_id = "${yandex_vpc_subnet.sub_a.id}"
    assign_public_ip = true
  }
  access {
    web_sql = true
    data_lens = true
  }
 }
