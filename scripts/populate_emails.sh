#!/bin/bash

# Very basic script to populate a test email locally via SSH or SSM agent.
# Connect to the mail server instance and run to create a test email.
curl smtp://localhost:1025 \
  --mail-from "test@example.com" \
  --mail-rcpt "recipient@example.com" \
  --upload-file - <<EOF
From: Test Sender <test@example.com>
To: Recipient <recipient@example.com>
Subject: Test Email

This is a test email sent via curl.
EOF