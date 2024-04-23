# Deployment Documentation

## Overview
This document outlines the steps and procedures for deploying the LAMP stack and Laravel application using Ansible.

## Deployment Process

### 1. Preparation
- Ensure that Ansible is installed on the control node.
- Set up SSH access from the control node to the target servers (master and slave).
- Prepare the Ansible playbook and inventory files.

### 2. Execution
- Run the Ansible playbook to deploy the LAMP stack and Laravel application.
- Verify that the deployment completes successfully.

## Deployment Steps

### Step 1: Installing Dependencies
- Update package repositories.
- Install necessary packages: Apache, MySQL, PHP, Git, etc.

### Step 2: Configuring LAMP Stack
- Set up Apache and MySQL configuration.
- Configure PHP and enable necessary modules.
- Set up virtual hosts for the Laravel application.

### Step 3: Installing Laravel Application
- Clone the Laravel application repository from GitHub.
- Install Composer globally.
- Install Laravel dependencies using Composer.
- Configure Laravel environment variables.

### Step 4: Setting Up Database
- Create MySQL database and user for Laravel application.
- Configure Laravel application to use MySQL database.

### Step 5: Running Migrations and Seeding
- Run Laravel migrations to create database tables.
- Seed the database with initial data (if needed).

### Step 6: Setting Up Cron Job
- Set up a cron job to perform server uptime checks.

## Post-Deployment Checks
- Verify that the Laravel application is accessible via the browser.
- Check the server uptime log to ensure cron job is working correctly.

## Troubleshooting
- Check Ansible logs for any errors or warnings during deployment.
- Review Apache and MySQL logs for any issues with the web server or database.

## Rollback Procedure
- If deployment fails or encounters critical issues, revert any configuration changes made during deployment.
- Investigate the cause of the failure and fix any issues before attempting deployment again.

## References
- Link to Ansible playbook and configuration files.
- (https://codewithsusan.com/notes/deploy-laravel-on-apache)
- https://php.watch/articles/php-8.3-install-upgrade-on-debian-ubuntu

