#!/bin/bash

# Prompt for the head node's hostname
read -p "Enter the head node's hostname: " head_node_hostname

# Prompt for the SSH password (will be the same for all nodes)
read -s -p "Enter SSH password: " ssh_password
echo

# Define the number of nodes in the cluster
num_nodes=3  # Adjust this number based on the total number of nodes in your cluster, including the head node

# Function to check connection for a given hostname
check_connection() {
    local hostname=$1
    echo "Attempting to connect to ${hostname}..."
    
    # Attempt to SSH to the hostname using sshpass for password-based authentication
    sshpass -p "$ssh_password" ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no "root@${hostname}" "exit" &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo "Successfully connected to ${hostname}"
    else
        echo "Failed to connect to ${hostname}"
    fi
}

# Start checking from the head node
echo "Checking connectivity for head node and other nodes..."

# Loop to check each node's connectivity
for (( i=1; i<=num_nodes; i++ )); do
    if [ $i -eq 1 ]; then
        # Check the head node
        check_connection "$head_node_hostname"
    else
        # Generate and check other nodes based on a pattern, e.g., appending numbers to the head node hostname
        node_hostname="${head_node_hostname//[0-9]/}${i}"  # Modify this line based on your naming convention
        check_connection "$node_hostname"
    fi
done
