<?php
$serverName = "terraform-20250702175525444800000001.ca7gi6mggaty.us-east-1.rds.amazonaws.com";
$database = "BookingSystem";
$username = "admin";
$password = "Winish-123";

$dsn = "mysql:server=$serverName;Database=$database";

// Set PDO options for better error handling
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,  // Disable emulated prepares for better security
];

try {
    // Create the PDO connection
    $conn = new PDO($dsn, $username, $password, $options);

    // Check if the connection is successful
    echo "Connected successfully";
}

catch (PDOException $e) {   
    // If connection fails, display error
    echo "Connection failed: " . $e->getMessage();
}
?>
