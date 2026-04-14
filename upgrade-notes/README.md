# Upgrade Notes

Operational notes and real-world observations from AWS RDS PostgreSQL
upgrade activities performed in production environments.

---

## Scenario 1: Post-Upgrade CPU Spike in Production

### Context
A PostgreSQL major version upgrade was performed during off-traffic hours
to minimize application impact. The database supported a production
workload with steady read/write traffic across multiple application layers.

### Issue Observed
Post-upgrade, CPU utilization spiked to nearly 100% during peak traffic
hours, leading to increased query latency.

### Root Cause Analysis
After the in-place upgrade, PostgreSQL query planner statistics became
stale. Once application traffic resumed, queries began using suboptimal
execution plans, resulting in excessive CPU usage.

### Resolution
- Executed `ANALYZE VERBOSE` across all databases in the instance
- Performed a controlled database restart to stabilize workloads

### Outcome
Following statistics refresh and restart:
- Query execution plans normalized
- CPU utilization returned to baseline levels
- No further performance degradation observed

### Key Takeaway
Always refresh database statistics after major version upgrades to
avoid query plan regressions and unexpected CPU spikes.

---

## Scenario 2: Post-Upgrade Connectivity Failure (PostgreSQL 13.20 → 15.15)

### Context
A major PostgreSQL version upgrade from **13.20 to 15.15** was performed
on an AWS RDS PostgreSQL instance as part of a planned upgrade cycle.

### Issue Observed
After the upgrade completed successfully, the application was **unable
to establish connections** to the database.

### Root Cause Analysis
During the upgrade, the database was associated with the **default
parameter group of PostgreSQL 15**, where SSL was enabled by default
(`ssl = 1`).  

The application and environment were **not configured to use SSL-based
connections**, resulting in connection failures post-upgrade.

### Resolution
- Identified SSL configuration mismatch in the PostgreSQL 15 parameter group
- Updated the parameter:
  ```text
  ssl = 0

---
## Scenario 3: Read Replica Connectivity Issue After In-Place Upgrade

### Context
A custom PostgreSQL parameter group was already associated with the
**primary RDS PostgreSQL instance**. A planned **in-place major version
upgrade** was triggered on the primary instance.

As part of the upgrade process, the **read replica was automatically
upgraded** from PostgreSQL **13.20 to 15.17**.

### Issue Observed
After the upgrade completed:
- Application users were **unable to connect to the read replica**
- The primary instance continued operating normally

### Root Cause Analysis
Although the primary instance retained the **custom parameter group**,
the **read replica was upgraded using the default PostgreSQL 15
parameter group**.

This resulted in a **configuration mismatch** between the primary and
read replica, causing connection failures on the read replica.

### Resolution
- Identified that the custom parameter group was **not applied to the read replica**
- Associated the same custom PostgreSQL 15 parameter group with the read replica
- Performed a **controlled reboot** of the read replica to apply changes

### Outcome
- Read replica connectivity was restored successfully
- Application traffic resumed without errors
- No data consistency or replication issues observed

### Key Takeaway
During in-place upgrades involving read replicas, always verify that
**custom parameter groups are explicitly applied to replicas**, as
default parameter groups may be associated after version upgrades.

---
