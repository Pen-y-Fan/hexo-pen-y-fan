---
title: How to send Emails using PHPMailer from Windows
date: 2021-09-14 19:44:04
tags: [Windows, PHP, Email, PHPMailer, Resource, Laragon]
categories: [Email]
---

This is a basic tutorial on how to send emails from Windows using PHPMailer. I'm using [Laragon](https://laragon.org/) as my Windows development environment.

## Find your Email setting

You need your SMTP or IMAP settings from your ISP. It should look like this:

![Plusnet SMTP and IMAP settings](https://i.imgur.com/t0DdGYU.png)

## In your project require PHPMailer

Create an empty project folder and require phpmailer

```sh
composer require phpmailer/phpmailer
```

## Use an example script

Phpmailer has many [example scripts](https://github.com/PHPMailer/PHPMailer/tree/master/examples). You will need to choose the best one based on your settings from your ISP.

My ISP only requires the outgoing mail server and port (STARTTLS is Yes based on the port 587), I therefore used the [smtp_no_auth.phps](https://github.com/PHPMailer/PHPMailer/blob/master/examples/smtp_no_auth.phps) script as my starting point. Save it in *src* directory as **smtp_no_auth.php**, then I modified the script with setting with my ISP:

- In my case:
  - Outgoing server: relay.plus.net = `$mail->Host = 'relay.plus.net';`
  - Outgoing port: 587 = `$mail->Port = 587;`


```php
<?php
// Import PHPMailer classes into the global namespace
// These must be at the top of your script, not inside a function
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

// Load Composer's autoloader
require __DIR__ . '/../vendor/autoload.php';


try {

    // Create an instance; passing `true` enables exceptions
    $mail = new PHPMailer(true);
    // Tell PHPMailer to use SMTP
    $mail->isSMTP();
    // Enable SMTP debugging
    // SMTP::DEBUG_OFF = off (for production use)
    // SMTP::DEBUG_CLIENT = client messages
    // SMTP::DEBUG_SERVER = client and server messages
    $mail->SMTPDebug = SMTP::DEBUG_SERVER;

    // Set the hostname of the mail server
    $mail->Host = 'relay.plus.net';
    // Set the SMTP port number - likely to be 25, 465 or 587
    $mail->Port = 587;

    // We don't need to set this as it's the default value
    // $mail->SMTPAuth = false;
    // Set who the message is to be sent from
    $mail->setFrom('from@example.com', 'Pen-y-Fan');
    // Set an alternative reply-to address
    //     $mail->addReplyTo('replyto@example.com', 'First Last');
    // Set who the message is to be sent to
    $mail->addAddress('my-email@my-isp.com', 'Pen-y-Fan');


    // Content
    $mail->isHTML(true);                                  // Set email format to HTML
    $mail->Subject = 'Here is the subject';
    $mail->Body = 'This is the HTML message body <b>in bold!</b>';
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

    $mail->send();
    echo 'Message has been sent';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
```

## Send it!

Then you can run the script:

```sh
php -f src/smtp_no_auth.php
```

You will see the debug message in your console:


```text
...
2021-08-24 23:01:05	SERVER -> CLIENT: 250 IfPhmrsuy6wwFIfPim0eEe mail accepted for delivery
2021-08-24 23:01:05	CLIENT -> SERVER: QUIT
2021-08-24 23:01:05	SERVER -> CLIENT: 221 avasout07 smtp closing connection
Message has been sent
Process finished with exit code 0
```

## Check your email client

Wait a few seconds and the email will be delivered to your inbox.

![Email Successfully sent](https://i.imgur.com/QHUK0gQ.png "Email Successfully sent")

## Conclusion

You will need to adjust the script you use based on your authentication and setting from your ISP.

Laragon automatically added a self-signed certificate to **php.ini** to allow secure transmission.

I hope this helps.
