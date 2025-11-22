<?php

require '../database.php';

function register($username, $email, $password) {
    global $conn;

    // Check if email exists
    $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        return ['status' => 'error', 'message' => 'Email already registered'];
    }

    // Hash the password
    $hashed_password = password_hash($password, PASSWORD_BCRYPT);

    // Insert new user
    $stmt = $conn->prepare("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $username, $email, $hashed_password);

    if ($stmt->execute()) {
        return ['status' => 'success', 'message' => 'User registered successfully'];
    } else {
        return ['status' => 'error', 'message' => 'Registration failed'];
    }

    $stmt->close();
}

switch ($_SERVER['REQUEST_METHOD']) {
    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        $username = $data['username'];
        $email = $data['email'];
        $password = $data['password'];

        $result = register($username, $email, $password);

        header('Content-Type: application/json');
        http_response_code($result['status'] === 'success' ? 201 : 400);
        echo json_encode($result);
        break;
    default:
        header('Content-Type: application/json');
        http_response_code(405);
        echo json_encode(['status' => 'error', 'message' => 'Method Not Allowed']);
        break;
}