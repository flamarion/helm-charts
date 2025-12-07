# ClickHouse Helm Chart

A Helm chart for deploying ClickHouse cluster with ClickHouse Keeper.

## Overview

This Helm chart deploys a ClickHouse distributed system consisting of:
- ClickHouse Server: A distributed database system with multiple replicas in a single shard
- ClickHouse Keeper: A ZooKeeper-compatible service for cluster coordination

## Features

- **Single-shard Architecture**: Multiple replicas in a single shard for high availability
- **ClickHouse Keeper Integration**: Dedicated 3-node ClickHouse Keeper for coordination
- **Configurable Resources**: Adjust CPU, memory, and storage based on workload
- **Prometheus Metrics**: Optional metrics endpoint for monitoring
- **Pod Anti-Affinity**: Configure pod distribution across nodes
- **S3 Object Storage**: Integration with S3-compatible storage systems
- **S3 Backup Support**: Dedicated S3 disk for backup and restore operations

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installation

```bash
helm repo add flamarion-charts https://flamarion.github.io/helm-charts
helm repo update
helm install my-release flamarion-charts/clickhouse
```

Or to install from a local checkout:

```bash
helm install my-release ./charts/clickhouse
```

## Configuration

The following table lists the configurable parameters for both ClickHouse Server and Keeper components.

### Common Settings

| Parameter         | Description                  | Default                |
| ----------------- | ---------------------------- | ---------------------- |
| `clusterName`     | ClickHouse cluster name      | `clickhouse_cluster`   |
| `logLevel`        | Log level for all components | `information`          |
| `metrics.enabled` | Enable Prometheus metrics    | `false`                |
| `metrics.port`    | Port for Prometheus metrics  | `9363`                 |
| `auth.username`   | Admin username               | `admin`                |
| `auth.password`   | Admin password               | `changeme`             |

### ClickHouse Server

| Parameter                                 | Description                                                | Default                        |
| ----------------------------------------- | ---------------------------------------------------------- | ------------------------------ |
| `clickhouse.replicas`                     | Number of ClickHouse server replicas                       | `3`                            |
| `clickhouse.image.repository`             | ClickHouse server image repository                         | `clickhouse/clickhouse-server` |
| `clickhouse.image.tag`                    | ClickHouse server image tag                                | `25.3.2`                       |
| `clickhouse.service.type`                 | Service type for ClickHouse server                         | `ClusterIP`                    |
| `clickhouse.service.ports.http`           | HTTP port for ClickHouse server                            | `8123`                         |
| `clickhouse.service.ports.tcp`            | Native protocol port for ClickHouse server                 | `9000`                         |
| `clickhouse.service.ports.intrsrvhttp`    | Interserver HTTP port                                      | `9009`                         |
| `clickhouse.resources`                    | Resource limits and requests for ClickHouse server         | `{}`                           |
| `clickhouse.persistence.size`             | Size of persistent volume for ClickHouse server (min 20Gi) | `30Gi`                         |
| `clickhouse.persistence.storageClassName` | Storage class for PVCs                                     | `""`                           |
| `clickhouse.persistence.accessModes`      | PVC access modes                                           | `["ReadWriteOnce"]`            |
| `clickhouse.antiAffinity`                 | Anti-affinity rules for server pods                        | `{}`                           |
| `clickhouse.objectStorage.enabled`        | Enable S3 object storage for data                          | `false`                        |

### ClickHouse Keeper

| Parameter                             | Description                             | Default                        |
| ------------------------------------- | --------------------------------------- | ------------------------------ |
| `keeper.image.repository`             | ClickHouse Keeper image repository      | `clickhouse/clickhouse-keeper` |
| `keeper.image.tag`                    | ClickHouse Keeper image tag             | `25.3.2`                       |
| `keeper.service.type`                 | Service type for ClickHouse Keeper      | `ClusterIP`                    |
| `keeper.service.ports.keeper`         | Keeper client port                      | `9181`                         |
| `keeper.service.ports.http`           | HTTP port for Keeper                    | `9182`                         |
| `keeper.service.ports.raft`           | Raft protocol port                      | `9234`                         |
| `keeper.resources`                    | Resource limits and requests for Keeper | See values.yaml                |
| `keeper.persistence.size`             | Size of persistent volume for Keeper    | `5Gi`                          |
| `keeper.persistence.storageClassName` | Storage class for PVCs                  | `""`                           |
| `keeper.persistence.accessModes`      | PVC access modes                        | `["ReadWriteOnce"]`            |
| `keeper.antiAffinity`                 | Anti-affinity rules for keeper pods     | `{}`                           |

### Backup Configuration

| Parameter                                    | Description                                                            | Default                        |
| -------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------ |
| `backup.enabled`                             | Enable both backup disk and scheduled backups                          | `false`                        |
| `backup.image.repository`                    | Image for backup container                                             | `clickhouse/clickhouse-server` |
| `backup.image.tag`                           | Image tag for backup container                                         | `25.3.2`                       |
| `backup.s3.bucket`                           | S3 bucket for backups (should be different from object storage bucket) | `""`                           |
| `backup.s3.endpoint`                         | S3 endpoint for backups                                                | `""`                           |
| `backup.s3.auth.credentials.enabled`         | Use direct credentials for S3 authentication                           | `false`                        |
| `backup.s3.auth.credentials.accessKeyId`     | S3 Access Key ID                                                       | `""`                           |
| `backup.s3.auth.credentials.secretAccessKey` | S3 Secret Access Key                                                   | `""`                           |
| `backup.s3.auth.useIam.enabled`              | Use IAM authentication                                                 | `false`                        |
| `backup.s3.auth.useIam.region`               | AWS Region for IAM authentication                                      | `""`                           |
| `backup.schedule`                            | Cron schedule for automated backups                                    | `"0 2 * * *"`                  |
| `backup.retentionDays`                       | Days to keep backups (0 = keep forever)                                | `7`                            |
| `backup.excludeDatabases`                    | List of databases to exclude from backup                               | `[]`                           |
| `backup.backupDirectory`                     | Directory path within the S3 bucket to store backups                   | `"clickhouse-backups"`         |
| `backup.parameters.compression`              | Compression method for backups (zstd, lz4, none)                       | `"zstd"`                       |
| `backup.parameters.compressionLevel`         | Compression level (higher = better compression but slower)             | `1`                            |
| `backup.resources`                           | Resource limits and requests for backup jobs                           | See values.yaml                |

## Architecture

The chart deploys:
1. A StatefulSet for ClickHouse Server with configurable number of replicas (default: 3)
2. A StatefulSet for ClickHouse Keeper with exactly 3 nodes
3. Corresponding Services for both components
4. ConfigMaps with ClickHouse and Keeper configurations

### Deployment Details

- **Pod Identity**: Each pod has an init container that extracts its replica index from the pod name
- **Configuration Management**: ConfigMaps with checksums to trigger pod restarts when configurations change
- **Anti-Affinity**: Configurable pod distribution across nodes to improve availability
- **Security Context**: Customizable pod and container security contexts
- **Global Kubernetes Settings**: Common nodeSelector, tolerations, and affinity settings can be applied to all pods

## Resource Naming

The chart uses the Helm release name as the base for resource naming. By default, all resources follow this pattern:

- ClickHouse Server resources: `{release-name}-clickhouse`
- ClickHouse Keeper resources: `{release-name}-clickhouse-keeper`

For example, with release name `my-release`:

- Service Account: `my-release-clickhouse-sa`
- Server Services: `my-release-clickhouse`, `my-release-clickhouse-headless` 
- Server Pods: `my-release-clickhouse-0`, `my-release-clickhouse-1`, etc.
- Server PVCs: `data-my-release-clickhouse-0`, etc.
- Keeper Services: `my-release-clickhouse-keeper`, `my-release-clickhouse-keeper-headless`
- Keeper Pods: `my-release-clickhouse-keeper-0`, `my-release-clickhouse-keeper-1`, etc.
- Keeper PVCs: `data-my-release-clickhouse-keeper-0`, etc.

You can override the naming using `nameOverride` or `fullnameOverride` in your values file.

## Limitations

- The chart only supports a single shard with multiple replicas
- ClickHouse Keeper is fixed at 3 nodes

## S3 Storage Integration

The chart supports using S3-compatible object storage for ClickHouse data, which provides:
- Separation of storage and compute
- Cost-effective scaling of storage independent from compute resources
- Potential for improved data durability

> **Note:** S3 Object Storage is **disabled by default**. You need to explicitly enable and configure it if needed.
> Currently, only AWS S3 and S3-compatible storage systems (like MinIO) are supported.

To enable S3 storage, add the following to your values override file:

```yaml
clickhouse:
  objectStorage:
    enabled: true
    type: "s3"
    singleBucket:
      enabled: true
      endpoint: "http://s3.example.com"
      bucket: "clickhouse-data"
      auth:
        # Direct credentials authentication
        credentials:
          enabled: true
          accessKeyId: "YOUR_ACCESS_KEY"
          secretAccessKey: "YOUR_SECRET_KEY"
        # IAM authentication (alternative)
        useIam:
          enabled: false
          region: "us-east-1"
```

This configuration will:
1. Create a storage policy called `s3_main`
2. Configure an S3 disk with the specified endpoint, credentials, and bucket
3. Set up local caching to improve performance
4. Configure unique paths for each replica using the replica number

Tables using this configuration will store their data in S3 while maintaining local metadata and caches for performance.

### Implementation Details

The S3 storage implementation in this chart uses:
- Default storage policy set to S3 for all MergeTree tables
- Local disk cache for improved performance
- Separate storage paths for each replica using replica index
- Write-through caching for optimal performance

### Configuration Examples

**AWS S3:**
```yaml
clickhouse:
  objectStorage:
    enabled: true
    type: "s3"
    singleBucket:
      enabled: true
      endpoint: "s3.us-east-1.amazonaws.com"
      bucket: "clickhouse-data"
      auth:
        credentials:
          enabled: false
        useIam:
          enabled: true
          region: "us-east-1"
```

**MinIO:**
```yaml
clickhouse:
  objectStorage:
    enabled: true
    type: "s3"
    singleBucket:
      enabled: true
      endpoint: "minio.example.com:9000"
      bucket: "clickhouse-data"
      auth:
        credentials:
          enabled: true
          accessKeyId: "YOUR_ACCESS_KEY"
          secretAccessKey: "YOUR_SECRET_KEY"
        useIam:
          enabled: false
```

Each replica will store data in a unique path based on its replica index, such as: `clickhouse-data/clickhouse-0`, `clickhouse-data/clickhouse-1`, etc.

## S3 Backup Integration

The chart also supports configuring an S3 disk specifically for backup and restore operations. This allows you to:
- Perform backups directly to S3 storage
- Keep backups isolated from your primary data storage
- Automatically schedule and retain backups

> **Note:** S3 Backup Integration is **disabled by default**. You need to explicitly enable and configure it if needed.

> **Warning:** The backup disk should be used **ONLY** for BACKUP/RESTORE operations, not for MergeTree tables.
> Using the same disk for both storage and backups may cause conflicts and data corruption.
> Always use a **different S3 bucket** for backups than the one used for object storage.

To enable S3 backups, add the following to your values override file:

```yaml
backup:
  enabled: true
  s3:
    endpoint: "https://s3.us-east-1.amazonaws.com"
    bucket: "clickhouse-backups"
    auth:
      # Direct credentials authentication
      credentials:
        enabled: true
        accessKeyId: "YOUR_ACCESS_KEY"
        secretAccessKey: "YOUR_SECRET_KEY"
      # IAM authentication (alternative)
      useIam:
        enabled: false
        region: "us-east-1"
  # Cron schedule for backups (daily at 2 AM)
  schedule: "0 2 * * *"
  # Keep backups for 7 days
  retentionDays: 7
  # Optional: Exclude specific databases
  excludeDatabases:
    - "system"
    - "information_schema"
```

### How Backups Work

When backup is enabled:
1. A special S3 disk named `backups_disk` is configured in ClickHouse
2. A CronJob is created to perform scheduled backups according to your configuration
3. Backups are created using the `BACKUP ALL` command with optional database exclusions
4. Each backup is stored in the specified S3 bucket with a timestamp
5. Backups older than the retention period are automatically deleted

### Running Manual Backups

You can trigger a backup manually at any time by creating a job from the CronJob:

```bash
# Run the manual backup job (replace 'my-release' with your actual release name)
kubectl create job --from=cronjob/my-release-clickhouse-backup my-release-clickhouse-backup-manual-$(date +%Y%m%d%H%M%S) -n your-namespace
```

### Backup Exclusions

You can exclude specific databases from your backups:

```yaml
backup:
  # ... other settings ...
  excludeDatabases:
    - "system"
    - "information_schema"
    - "temp_database"
```

### Restore Process

The backup solution focuses on creating backups. For restore operations, you need to use ClickHouse's built-in `RESTORE` command:

```sql
-- Connect to ClickHouse and run:
RESTORE TABLE your_database.your_table FROM 
  Disk('backups_disk', 'clickhouse-backups/backup-YYYYMMDD-HHMMSS.zip');
```

Complete backup restoration should be performed manually according to your specific requirements.

## Pod Anti-Affinity

The chart supports pod anti-affinity rules for both ClickHouse Server and Keeper to ensure high availability by distributing pods across different nodes. You can configure anti-affinity in the values file:

### Soft Anti-Affinity Example (Preferred)

```yaml
clickhouse:
  antiAffinity:
    podAntiAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app.kubernetes.io/component: server
          topologyKey: "kubernetes.io/hostname"
```

### Hard Anti-Affinity Example (Required)

```yaml
keeper:
  antiAffinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchLabels:
            app.kubernetes.io/component: keeper
        topologyKey: "kubernetes.io/hostname"
```

Hard anti-affinity ensures pods are never scheduled on the same node, but can prevent pod scheduling if insufficient nodes are available. Soft anti-affinity prefers different nodes but allows co-location if necessary.

## Advanced Kubernetes Configuration

### Node Placement

You can control where pods are scheduled using standard Kubernetes features:

```yaml
# Apply to all pods
nodeSelector:
  disktype: ssd
  kubernetes.io/os: linux

# Define tolerations for all pods
tolerations:
- key: "special-hardware"
  operator: "Equal"
  value: "true"
  effect: "NoSchedule"

# Global affinity rules applied to all pods
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/e2e-az-name
          operator: In
          values:
          - us-east-1a
          - us-east-1b
```

These settings are applied to all pods in addition to component-specific settings like `clickhouse.antiAffinity` and `keeper.antiAffinity`. 