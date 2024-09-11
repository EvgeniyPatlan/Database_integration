
#!/bin/bash

# This script automates the start of either standalone or cluster setups based on the provided argument.

# Check if a parameter was passed
if [ -z "$1" ]; then
  echo "Usage: ./start_setup.sh [standalone|cluster]"
  exit 1
fi

# Check if Docker Compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

# Function to start the standalone setup
start_standalone() {
  echo "Starting standalone setup for PostgreSQL, MySQL, and MongoDB..."

  # Navigate to the standalone directory if needed
  cd standalone

  # Start Docker Compose for standalone
  docker-compose up -d

  # Wait for the containers to initialize
  echo "Waiting for the standalone databases to initialize..."
  sleep 20

  # Run the FDW setup script for PostgreSQL
  ./setup_fdw.sh

  # Populate the databases with data
  echo "Populating MySQL and MongoDB with initial data..."
  python3 populate_data.py

  echo "Standalone setup complete."
}

# Function to start the cluster setup
start_cluster() {
  echo "Starting cluster setup for PostgreSQL, MySQL, and MongoDB..."

  # Navigate to the cluster directory if needed
  cd cluster

  # Start Docker Compose for cluster
  docker-compose -f docker-compose-cluster.yml up -d

  # Wait for the containers to initialize
  echo "Waiting for the cluster databases to initialize..."
  sleep 30

  echo "Cluster setup complete. Databases are initialized with 1000 records."
}

# Parse the input argument
case "$1" in
  standalone)
    start_standalone
    ;;
  cluster)
    start_cluster
    ;;
  *)
    echo "Invalid option. Use 'standalone' or 'cluster'."
    exit 1
    ;;
esac

