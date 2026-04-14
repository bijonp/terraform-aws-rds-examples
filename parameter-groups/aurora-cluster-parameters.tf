resource "aws_rds_cluster_parameter_group" "aurora_postgres_cluster" {
  name        = "${var.name}-aurora-postgres-cluster-pg"
  family      = var.aurora_postgres_family
  description = "Aurora PostgreSQL cluster parameter group"
  tags        = var.tags

  # ==================================================
  # Compatibility / Global behavior
  # ==================================================

  # Set a consistent timezone across the cluster
  parameter {
    name         = "timezone"
    value        = var.db_timezone
    apply_method = "immediate"
  }

  # If you had client/app compatibility issues during pgAdmin or client upgrades,
  # you may control hashing algorithm used for new passwords.
  # (Keep commented unless your application explicitly needs it.)
  # parameter {
  #   name         = "password_encryption"
  #   value        = "scram-sha-256"
  #   apply_method = "immediate"
  # }

  # ==================================================
  # Logical replication (enable only if you use DMS / Debezium / CDC)
  # ==================================================
  parameter {
    name         = "rds.logical_replication"
    value        = var.enable_logical_replication ? "1" : "0"
    apply_method = "pending-reboot"
  }

  # ==================================================
  # Logging defaults (cluster-scope knobs)
  # ==================================================
  parameter {
    name         = "log_min_duration_statement"
    value        = var.log_min_duration_statement_ms
    apply_method = "immediate"
  }

  # ==================================================
  # Session safety (guardrails)
  # ==================================================
  parameter {
    name         = "idle_in_transaction_session_timeout"
    value        = var.idle_in_tx_timeout_ms
    apply_method = "immediate"
  }
}
