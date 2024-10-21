$nodeHostnames = @(
    "headnode",    
    "node1",       
    "node2",
    "node3"
)

foreach ($node in $nodeHostnames) {
    $ping = Test-Connection -ComputerName $node -Count 1 -Quiet
    if ($ping) {
        Write-Output "$node is connected."
    } else {
        Write-Output "Error: $node was not able to connect."
    }
}
