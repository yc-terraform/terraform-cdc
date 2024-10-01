module "db" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-postgresql.git?ref=master"

  network_id  = yandex_vpc_network.vpc.id
  name        = var.userdb
  description = "Single-node PostgreSQL cluster for CDC"
  security_groups_ids_list = [yandex_vpc_security_group.db_sg.id]
  maintenance_window = {
    type = "WEEKLY"
    day  = "SUN"
    hour = "02"
  }

  access_policy = {
    web_sql = true
  }

  performance_diagnostics = {
    enabled = true
  }

  hosts_definition = [
    {
      zone             = var.yc_zone
      assign_public_ip = true
      subnet_id        = yandex_vpc_subnet.sub_a.id
    }
  ]

  postgresql_config = {
    max_connections                = 395
    enable_parallel_hash           = true
    autovacuum_vacuum_scale_factor = 0.34
    default_transaction_isolation  = "TRANSACTION_ISOLATION_READ_COMMITTED"
    shared_preload_libraries       = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
  }

  default_user_settings = {
    default_transaction_isolation = "read committed"
    log_min_duration_statement    = 5000
  }

  databases = [
    {
      name       = var.userdb
      owner      = var.userdb
      lc_collate = "ru_RU.UTF-8"
      lc_type    = "ru_RU.UTF-8"
      extensions = ["uuid-ossp", "xml2"]
    }
  ]

  owners = [
    {
      name       = var.userdb
      password = var.password
      conn_limit = 15
      grants = [ "mdb_replication" ]
    }
  ]

  users = [
    {
      name        = "${var.userdb}-guest"
      conn_limit  = 30
      password = var.password
      permissions = [var.userdb]
      grants = [ "mdb_replication" ]
      settings = {
        pool_mode                   = "transaction"
        prepared_statements_pooling = true
      }
    }
  ]
}