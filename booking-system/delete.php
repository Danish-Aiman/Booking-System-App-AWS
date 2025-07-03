<?php
include 'db.php';
$id = $_POST['id'];
$conn->query("DELETE FROM appointments WHERE id = $id");
header("Location: admin_view.php");
?>
