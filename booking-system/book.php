<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header("Location: index.php");
    exit();
}

include 'db.php'; // Your PDO connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $full_name = isset($_POST['full_name']) ? trim($_POST['full_name']) : '';
    $ic_number = isset($_POST['ic_number']) ? trim($_POST['ic_number']) : '';
    $date = isset($_POST['date']) ? $_POST['date'] : '';
    $time = isset($_POST['time']) ? $_POST['time'] : '';
    $credit_card_number = isset($_POST['credit_card_number']) ? trim($_POST['credit_card_number']) : '';

    if ($full_name === '' || $ic_number === '' || $date === '' || $time === '' || $credit_card_number === '') {
        echo "Please fill in all fields.";
        exit();
    }

    try {
        $stmt = $conn->prepare("INSERT INTO appointments (user_id, full_name, ic_number, date, time, credit_card_number) VALUES (?, ?, ?, ?, ?, ?)");
        $stmt->execute([$_SESSION['user_id'], $full_name, $ic_number, $date, $time, $credit_card_number]);

        echo "Appointment booked successfully! <a href='book_form.php'>Book another appointment</a>";

    } catch (PDOException $e) {
        echo "Error booking appointment: " . $e->getMessage();
        exit();
    }
} else {
    echo "Invalid request method.";
}
?>
