<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'path/to/PHPMailer/src/Exception.php';
require 'path/to/PHPMailer/src/PHPMailer.php';
require 'path/to/PHPMailer/src/SMTP.php';

$mail = new PHPMailer(true);

try {
    $mail->isSMTP();
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'zalavadiyadharma@gmail.com';
    $mail->Password   = 'jbtd jtzm ydlg gqza'; 
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port       = 587;

    $mail->setFrom('zalavadiyadharma@gmail.com', 'Website Contact Form');
    $mail->addAddress('zalavadiyadharma@gmail.com'); 

    $mail->isHTML(false);
    $mail->Subject = "New Form Submission: " . $_POST['firstname'];
    $mail->Body    = "Name: " . $_POST['firstname'] . " " . $_POST['lastname'] . "\n" .
                     "Country: " . $_POST['country'] . "\n" .
                     "Message: " . $_POST['subject'];

    $mail->send();
    header("Location: thank_you.html");
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
?>
