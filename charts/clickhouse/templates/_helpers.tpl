{{/*
Expand the name of the chart.
*/}}
{{- define "clickhouse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clickhouse.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Name for keeper resources
*/}}
{{- define "clickhouse.keeperName" -}}
{{- printf "%s-keeper" (include "clickhouse.fullname" .) }}
{{- end }}

{{/*
Name for server resources
*/}}
{{- define "clickhouse.serverName" -}}
{{- include "clickhouse.fullname" . }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "clickhouse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "clickhouse.labels" -}}
helm.sh/chart: {{ include "clickhouse.chart" . }}
{{ include "clickhouse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "clickhouse.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clickhouse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "clickhouse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (printf "%s-sa" (include "clickhouse.fullname" .)) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate ClickHouse persistence size
*/}}
{{- define "clickhouse.validatePersistenceSize" -}}
{{- $persistenceSize := regexReplaceAll "Gi$" .Values.clickhouse.persistence.size "" | atoi -}}
{{- if lt $persistenceSize 20 -}}
{{- fail "ClickHouse persistence size must be at least 20Gi" -}}
{{- end -}}
{{- end -}}

{{/*
Generate a flexible pod hostname based on component name, index and namespace
*/}}
{{- define "clickhouse.podHostname" -}}
{{- $componentName := index . 0 -}}
{{- $index := index . 1 -}}
{{- $namespace := index . 2 -}}
{{- printf "%s-%d.%s-headless.%s.svc.cluster.local" $componentName $index $componentName $namespace -}}
{{- end }}

{{/*
Generate a server XML block for raft configuration
*/}}
{{- define "clickhouse.serverXmlBlock" -}}
{{- $componentName := index . 0 -}}
{{- $port := index . 1 -}}
{{- $namespace := index . 2 -}}
{{- $count := index . 3 -}}
{{- range $i := until $count }}
          <server>
            <id>{{ $i }}</id>
            <hostname>{{ include "clickhouse.podHostname" (list $componentName $i $namespace) }}</hostname>
            <port>{{ $port }}</port>
          </server>
{{- end }}
{{- end }}

{{/*
Generate replica XML blocks for ClickHouse server configuration
*/}}
{{- define "clickhouse.replicaXmlBlock" -}}
{{- $componentName := index . 0 -}}
{{- $port := index . 1 -}}
{{- $namespace := index . 2 -}}
{{- $count := index . 3 -}}
{{- range $i := until $count }}
                    <replica>
                        <host>{{ include "clickhouse.podHostname" (list $componentName $i $namespace) }}</host>
                        <port>{{ $port }}</port>
                    </replica>
{{- end }}
{{- end }}

{{/*
Generate ZooKeeper node XML blocks for ClickHouse server configuration
*/}}
{{- define "clickhouse.zookeeperNodeXmlBlock" -}}
{{- $componentName := index . 0 -}}
{{- $port := index . 1 -}}
{{- $namespace := index . 2 -}}
{{- $count := index . 3 -}}
{{- range $i := until $count }}
            <node>
                <host>{{ include "clickhouse.podHostname" (list $componentName $i $namespace) }}</host>
                <port>{{ $port }}</port>
            </node>
{{- end }}
{{- end }}

{{/*
Validate S3 Object Storage configuration
*/}}
{{- define "clickhouse.validateObjectStorage" -}}
{{- if .Values.clickhouse.objectStorage.enabled -}}
  {{- /* Validate storage type */ -}}
  {{- if or (not .Values.clickhouse.objectStorage.type) (eq .Values.clickhouse.objectStorage.type "") -}}
    {{- fail "When object storage is enabled, storage type must be provided" -}}
  {{- end -}}
  {{- $validTypes := list "s3" "azure_blob_storage" "hdfs" "web" "disk" -}}
  {{- if not (has .Values.clickhouse.objectStorage.type $validTypes) -}}
    {{- fail (printf "Invalid storage type: %s. Valid types are: %s" .Values.clickhouse.objectStorage.type (join ", " $validTypes)) -}}
  {{- end -}}

  {{- if or (not .Values.clickhouse.objectStorage.singleBucket.endpoint) (eq .Values.clickhouse.objectStorage.singleBucket.endpoint "") -}}
    {{- fail "When object storage is enabled, endpoint must be provided" -}}
  {{- end -}}
  {{- if or (not .Values.clickhouse.objectStorage.singleBucket.bucket) (eq .Values.clickhouse.objectStorage.singleBucket.bucket "") -}}
    {{- fail "When object storage is enabled, bucket must be provided" -}}
  {{- end -}}
  
  {{- /* Validate authentication methods */ -}}
  {{- if and (not .Values.clickhouse.objectStorage.singleBucket.auth.useIam.enabled) (not .Values.clickhouse.objectStorage.singleBucket.auth.credentials.enabled) -}}
    {{- fail "Either credentials or IAM authentication must be enabled" -}}
  {{- end -}}
  
  {{- /* Validate credentials auth if enabled */ -}}
  {{- if .Values.clickhouse.objectStorage.singleBucket.auth.credentials.enabled -}}
    {{- if or (not .Values.clickhouse.objectStorage.singleBucket.auth.credentials.accessKeyId) (eq .Values.clickhouse.objectStorage.singleBucket.auth.credentials.accessKeyId "") -}}
      {{- fail "When object storage is enabled with credentials auth, accessKeyId must be provided" -}}
    {{- end -}}
    {{- if or (not .Values.clickhouse.objectStorage.singleBucket.auth.credentials.secretAccessKey) (eq .Values.clickhouse.objectStorage.singleBucket.auth.credentials.secretAccessKey "") -}}
      {{- fail "When object storage is enabled with credentials auth, secretAccessKey must be provided" -}}
    {{- end -}}
  {{- end -}}
  
  {{- /* Validate IAM auth if enabled */ -}}
  {{- if .Values.clickhouse.objectStorage.singleBucket.auth.useIam.enabled -}}
    {{- if or (not .Values.clickhouse.objectStorage.singleBucket.auth.useIam.region) (eq .Values.clickhouse.objectStorage.singleBucket.auth.useIam.region "") -}}
      {{- fail "When using IAM authentication, region must be provided" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate S3 Backup configuration
*/}}
{{- define "clickhouse.validateBackup" -}}
{{- if .Values.backup.enabled -}}
  {{- /* Validate basic parameters */ -}}
  {{- if or (not .Values.backup.s3.bucket) (eq .Values.backup.s3.bucket "") -}}
    {{- fail "When backup is enabled, backup.s3.bucket must be provided" -}}
  {{- end -}}
  {{- if or (not .Values.backup.s3.endpoint) (eq .Values.backup.s3.endpoint "") -}}
    {{- fail "When backup is enabled, backup.s3.endpoint must be provided" -}}
  {{- end -}}
  
  {{- /* Validate that backup bucket is different from object storage bucket if both are enabled */ -}}
  {{- if .Values.clickhouse.objectStorage.enabled -}}
    {{- if eq .Values.backup.s3.bucket .Values.clickhouse.objectStorage.singleBucket.bucket -}}
      {{- fail "The backup S3 bucket must be different from the object storage bucket to avoid conflicts" -}}
    {{- end -}}
  {{- end -}}
  
  {{- /* Validate authentication methods */ -}}
  {{- if and (not .Values.backup.s3.auth.useIam.enabled) (not .Values.backup.s3.auth.credentials.enabled) -}}
    {{- fail "Either credentials or IAM authentication must be enabled for backup" -}}
  {{- end -}}
  
  {{- /* Validate credentials auth if enabled */ -}}
  {{- if .Values.backup.s3.auth.credentials.enabled -}}
    {{- if or (not .Values.backup.s3.auth.credentials.accessKeyId) (eq .Values.backup.s3.auth.credentials.accessKeyId "") -}}
      {{- fail "When backup is enabled with credentials auth, accessKeyId must be provided" -}}
    {{- end -}}
    {{- if or (not .Values.backup.s3.auth.credentials.secretAccessKey) (eq .Values.backup.s3.auth.credentials.secretAccessKey "") -}}
      {{- fail "When backup is enabled with credentials auth, secretAccessKey must be provided" -}}
    {{- end -}}
  {{- end -}}
  
  {{- /* Validate IAM auth if enabled */ -}}
  {{- if .Values.backup.s3.auth.useIam.enabled -}}
    {{- if or (not .Values.backup.s3.auth.useIam.region) (eq .Values.backup.s3.auth.useIam.region "") -}}
      {{- fail "When using IAM authentication for backup, region must be provided" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate S3 authentication configuration block based on authentication method
*/}}
{{- define "clickhouse.s3AuthConfig" -}}
<endpoint from_env="S3_ENDPOINT" />
{{- if .Values.clickhouse.objectStorage.singleBucket.auth.useIam.enabled }}
<use_environment_credentials>true</use_environment_credentials>
<region>{{ .Values.clickhouse.objectStorage.singleBucket.auth.useIam.region }}</region>
{{- else }}
<access_key_id>{{ .Values.clickhouse.objectStorage.singleBucket.auth.credentials.accessKeyId }}</access_key_id>
<secret_access_key>{{ .Values.clickhouse.objectStorage.singleBucket.auth.credentials.secretAccessKey }}</secret_access_key>
{{- end }}
{{- end }}

{{/*
Generate S3 backup authentication configuration block based on authentication method
*/}}
{{- define "clickhouse.s3BackupAuthConfig" -}}
<endpoint from_env="S3_BACKUP_ENDPOINT" />
{{- if .Values.backup.s3.auth.useIam.enabled }}
<use_environment_credentials>true</use_environment_credentials>
<region>{{ .Values.backup.s3.auth.useIam.region }}</region>
{{- else }}
<access_key_id>{{ .Values.backup.s3.auth.credentials.accessKeyId }}</access_key_id>
<secret_access_key>{{ .Values.backup.s3.auth.credentials.secretAccessKey }}</secret_access_key>
{{- end }}
{{- end }} 