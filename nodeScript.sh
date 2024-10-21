#!/bin/bash

# Prompt for the head node's hostname (e.g., node1 or node01)
read -p "Enter the head node's hostname (e.g., node1): " head_node_hostname

# Prompt for the SSH password (will be the same for all nodes)
read -s -p "Enter SSH password: " ssh_password
echo

# Extract the base name and number part from the head node's hostname
base_name=$(echo "$head_node_hostname" | sed 's/[0-9]*$//')
start_number=$(echo "$head_node_hostname" | grep -o '[0-9]*$')
start_number=${start_number:-1}  # Default to 1 if no number is found

# Define the maximum number of nodes to scan in the cluster (adjust as needed)
max_nodes=20  # Define a reasonable maximum based on your cluster size

# Function to check connection for a given hostname
check_connection() {
    local hostname=$1
    sshpass -p "$ssh_password" ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no "root@${hostname}" "exit" &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo "$hostname is connected."
    else
        echo "Error: $hostname was not able to connect."
    fi
}

# Discover and check all nodes in the cluster
echo "Checking connectivity for nodes in the cluster..."

for (( i=0; i<max_nodes; i++ )); do
    # Calculate the current node number and hostname
    current_number=$(printf "%d" $((start_number + i)))
    node_hostname="${base_name}${current_number}"
    
    # Check the connectivity of the generated hostname
    check_connection "$node_hostname"
done
