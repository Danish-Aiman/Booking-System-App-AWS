<?php
session_start();
if (!isset($_SESSION['admin_id'])) {
    header("Location: admin.html");
    exit();
}

include 'db.php'; // Assumes $conn is a PDO instance connected to SQL Server

try {
    $sql = "SELECT 
                a.id, 
                a.[full_name], 
                a.[ic_number], 
                a.[date], 
                a.[time], 
                a.[credit_card_number], 
                u.name 
            FROM appointments a 
            JOIN users u ON a.user_id = u.id";

    $stmt = $conn->query($sql);
    $appointments = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Error fetching appointments: " . $e->getMessage());
}
?>

<!DOCTYPE html>
<html data-bs-theme="light" lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no" />
    <title>Appointments</title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="assets/css/style.css" />
    <link rel="stylesheet" href="assets/css/style-1.css" />
</head>

<body>
    <h2>All Appointments</h2>
    <div class="table-responsive" style="width: 1396.2px;">
        <table class="table table-striped table-striped-columns table-bordered">
            <thead>
                <tr>
                    <th style="border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">Full Name</th>
                    <th style="border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;width: 114.4px;">IC No.</th>
                    <th style="width: 89.9px;border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">Date</th>
                    <th style="width: 52.9px;border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">Time</th>
                    <th style="width: 154.3px;border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">Credit Card No.</th>
                    <th style="width: 70.8px;border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">Action</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($appointments as $row) : ?>
                    <tr>
                        <td class="text-break" style="border-style: solid;border-top-style: none;border-right-color: #dddddd;border-left-color: #dddddd;width: 146.5px;">
                            <?= htmlspecialchars($row['full_name']) ?>
                        </td>
                        <td style="border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">
                            <?= htmlspecialchars($row['ic_number']) ?>
                        </td>
                        <td style="border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">
                            <?= htmlspecialchars($row['date']) ?>
                        </td>
                        <td style="border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">
                            <?php 
                                $time = new DateTime($row['time']);
                                echo htmlspecialchars($time->format('H:i'));
                            ?>
                        </td>
                        <td style="border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">
                            <?= htmlspecialchars($row['credit_card_number']) ?>
                        </td>
                        <td style="border-style: solid;border-color: #f4f4f9;border-right-color: #dddddd;border-left-color: #dddddd;">
                            <form method="POST" action="delete.php" style="margin: 0px; width: 62px; padding: 0px; margin-left: 0px;">
                                <input type="hidden" name="id" value="<?= htmlspecialchars($row['id']) ?>" />
                                <button style="background: rgb(232,22,22); border: none; color: white; padding: 5px 10px; cursor: pointer;">Delete</button>
                            </form>
                        </td>
                    </tr>
                <?php endforeach; ?>
                <?php if (empty($appointments)) : ?>
                    <tr>
                        <td colspan="6" style="text-align: center;">No appointments found.</td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>
    <a href="admin_logout.php">Back to Login</a>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
