import paramiko
import time

# Define the nodes
nodes = [
    'head_node_ip',  # head node's IP
    'node1_ip',      # node's IPs
    'node2_ip',
    # Add as many nodes as needed
]

# SSH credentials
username = 'your_username'  # SSH username
password = 'your_password'  # SSH password

def check_connection(node_ip):
    try:
        print(f"Attempting to connect to {node_ip}...")
        ssh = paramiko.SSHClient()      #paramiko (python library that provides tools for ssh)
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(node_ip, username=username, password=password)
        
        print(f"Successfully connected to {node_ip}")
        ssh.close()
    except Exception as e:
        print(f"Failed to connect to {node_ip}: {str(e)}")

# Loop through each node and check the connection
for node in nodes:
    check_connection(node)
    #time.sleep(2)  # Optional delay between nodes
