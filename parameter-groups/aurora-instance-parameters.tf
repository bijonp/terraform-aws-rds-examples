resource "aws_db_parameter_group" "aurora_postgres_instance" {
  name        = "${var.name}-aurora-postgres-instance-pg"
  family      = var.aurora_postgres_family
  description = "Aurora PostgreSQL instance parameter group"
  tags        = var.tags

  # ==================================================
  # SECURITY / SSL
  # ==================================================

  # Enforce SSL for all client connections
  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  # ==================================================
  # LOGGING (CloudWatch / Performance Insights friendly)
  # ==================================================

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000" # ms (slow queries)
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_temp_files"
    value = "10240" # KB (10MB)
  }

  parameter {
    name  = "log_autovacuum_min_duration"
    value = "10000" # ms
  }

  # ==================================================
  # EXTENSIONS / DIAGNOSTICS
  # ==================================================

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "pg_stat_statements.max"
    value = "10000"
  }

  parameter {
    name  = "pg_stat_statements.track"
    value = "all"
  }

  parameter {
    name  = "pg_stat_statements.save"
    value = "1"
  }

  # ==================================================
  # MEMORY & PLANNER (Aurora‑safe)
  # NOTE: Aurora manages most memory internally
  # ==================================================

  parameter {
    name  = "work_mem"
    value = "65536" # KB = 64MB
  }

  parameter {
    name  = "maintenance_work_mem"
    value = "262144" # KB = 256MB
  }

  # ==================================================
  # AUTOVACUUM (Aurora-safe tuning)
  # ==================================================

  parameter {
    name  = "autovacuum"
    value = "1"
  }

  parameter {
    name  = "autovacuum_vacuum_scale_factor"
    value = "0.05"
  }

  parameter {
    name  = "autovacuum_analyze_scale_factor"
    value = "0.02"
  }

  parameter {
    name  = "autovacuum_vacuum_cost_delay"
    value = "2"
  }

  parameter {
    name  = "autovacuum_vacuum_cost_limit"
    value = "2000"
  }

  # ==================================================
  # SESSION SAFETY
  # ==================================================

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "600000" # ms = 10 minutes
  }

  parameter {
    name  = "statement_timeout"
    value = "0"
  }
}
