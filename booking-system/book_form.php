<?php
session_start();
if (!isset($_SESSION['user_id'])) {
    header("Location: index.html");
    exit();
}
?>

<!DOCTYPE html>
<html data-bs-theme="light" lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title>Book Appointment</title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/style-1.css">
</head>

<body>
    <header>
        <img style="text-align: center;display: block;margin: auto;width: 204px;margin-top: 30px;" src="assets/img/MMU_Logo.png">
    </header>

    <h2>Welcome, <?= $_SESSION['name'] ?>!</h2>

    <form method="POST" action="book.php">
        <span>Full Name: </span>
        <input type="text" name="full_name" required="">
        <span>&nbsp;IC No.: </span>
        <input type="text" name="ic_number" required="">
        <span> Date: </span><input type="date" name="date" required="">
        <br>
        <span> Time: </span><input type="time" name="time" required="">
        <br>
        <span>Credit Card Number: </span><input type="text" name="credit_card_number" required="">
        <br>
        <input type="submit" value="Book Appointment">
    </form>
    
    <a href="logout.php">Logout</a>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>