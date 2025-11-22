<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '../vendor/autoload.php';

$mail = new PHPMailer(true);

try {
    // SMTP Configuration
    $mail->isSMTP();
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'lianggonoa@gmail.com';          // email Gmail kamu
    $mail->Password   = 'jdsq jfnp asjb tzbz';      // app password 16 digit
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; // TLS
    $mail->Port       = 587;

    // Sender & Recipient
    $mail->setFrom('no-reply@carrental.com', 'Nama Kamu');
    $mail->addAddress('axellianggono@gmail.com', 'Nama Penerima');

    // Content
    $mail->isHTML(true);
    $mail->Subject = 'Test email dari localhost via Gmail SMTP';
    $mail->Body    = '<h3>Berhasil!</h3><p>Email dikirim via Gmail SMTP + PHPMailer.</p>';
    $mail->AltBody = 'Berhasil! Email dikirim via Gmail SMTP + PHPMailer.';

    $mail->send();
    echo "Email berhasil dikirim!";
} catch (Exception $e) {
    echo "Gagal dikirim. Error: {$mail->ErrorInfo}";
}
