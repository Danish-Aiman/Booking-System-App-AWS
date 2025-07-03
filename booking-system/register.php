<?php
include 'db.php'; // Make sure $conn is a PDO instance here

$name = $_POST['name'];
$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_DEFAULT);

try {
    $stmt = $conn->prepare("INSERT INTO users (name, email, password) VALUES (:name, :email, :password)");
    $stmt->bindParam(':name', $name, PDO::PARAM_STR);
    $stmt->bindParam(':email', $email, PDO::PARAM_STR);
    $stmt->bindParam(':password', $password, PDO::PARAM_STR);
    $stmt->execute();

        // Redirect to login page
    header("Location: index.html");
    exit(); // Important to stop script execution after redirect
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>
