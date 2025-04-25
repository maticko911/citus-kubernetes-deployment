## Overview

This repository provides a Helm chart for deploying a Citus Database cluster on Kubernetes. 
The chart is configured to deploy a basic Citus cluster consisting of:

* **1 Master Node:** The coordinator node responsible for query planning and distributing tasks to worker nodes.
* **2 Worker Nodes:** The data nodes where table shards are stored and query execution occurs.

This setup serves as a foundational deployment for development and testing purposes. Production environments may require further configuration and considerations for high availability, persistence, and resource management.

## Prerequisites

Before deploying this Helm chart, ensure the following prerequisites are met:

* **Kubernetes Cluster:** A running Kubernetes cluster (e.g., Minikube, kind, or a managed Kubernetes service). Tested with Kubernetes v1.20+.
* **Helm v3:** Helm package manager installed and configured to interact with your Kubernetes cluster.
* **kubectl:** Kubernetes command-line tool configured to connect to your cluster.
* **Docker:** If using a local Kubernetes environment with a Docker driver (like Minikube on macOS/Windows with Docker Desktop), Docker must be installed and running.
* **psql:** PostgreSQL client tools installed locally for interacting with the Citus database.

## Repository Structure

citus-helm/

├── citus/

│   ├── Chart.yaml          # Helm chart metadata
│   ├── templates/          # Kubernetes manifest templates
│   │   ├── master-deployment.yaml
│   │   ├── master-service.yaml
│   │   ├── worker-deployment.yaml
│   │   └── worker-service.yaml
│   └── values.yaml         # Default configuration values
└── init_database.sql       # SQL script for database initialization and sharding
└── README.md


## Deployment

1.  **Clone this repository:**
    ```bash
    git clone <REPOSITORY_URL>
    cd <REPOSITORY_DIRECTORY>
    ```

2.  **Install the Helm chart:**
    ```bash
    helm install citus-cluster ./citus
    ```
    This command deploys the Citus cluster to your Kubernetes cluster using the default configuration specified in `citus/values.yaml`.

3.  **Monitor the deployment:**
    Check the status of the deployed pods:
    ```bash
    kubectl get pods -l app.kubernetes.io/name=citus
    ```
    Ensure that the master and worker pods are in a `Running` state.

4.  **Port-forward to the Citus master:**
    To interact with the Citus master node from your local machine, set up port forwarding:
    ```bash
    kubectl port-forward service/citus-master-service 5432:5432
    ```
    (Note: If port 5432 is already in use, you can use a different local port, e.g., `kubectl port-forward service/citus-master-service 5433:5432` and adjust the `psql` connection accordingly.)

5.  **Initialize the database and shard the table:**
    Use `psql` to connect to the forwarded port and execute the initialization script:
    ```bash
    psql -h localhost -p 5432 -U postgres -f init_database.sql
    ```
    This script creates the `my_citus_db` database, connects to it, creates the `events` table, and distributes it across the worker nodes based on the `event_id` column.

## Configuration

The default configuration for the Citus cluster can be found in `citus/values.yaml`. You can customize various parameters, including:

* Number of worker nodes (`worker.replicas`)
* Resource requests and limits for master and worker nodes (`master.resources`, `worker.resources`)
* PostgreSQL image and version (`image.repository`, `image.tag`)
* Storage configurations 

