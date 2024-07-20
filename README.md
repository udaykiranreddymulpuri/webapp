This Spring Boot application is an Assignment Management System that allows users to create, update, and delete assignments. It also supports assignment submissions with validation checks, such as the maximum number of attempts and submission deadlines. The system includes user authentication using basic HTTP authentication with email and password.   Spring Boot,Databases,JPA,bcrypt,AWS SDK,statsD.

Assignment Management System - Technical Overview
Build and Run Instructions
1. Build the Project
    * Execute the command: mvn clean install
2. Run the Application
    * Execute the command: mvn spring-boot:run
Database Configuration
* PostgreSQL is configured to run locally on port 5432.
Application Features
* Health Check Endpoint
    * A basic health check endpoint has been implemented to monitor the application's health.
* Assignment Management Endpoints
    * Create Assignment: Users can create new assignments.
    * View Assignment: Users can view existing assignments.
    * Delete Assignment: Users can delete assignments.
    * Submit Assignment: Users can Submit assignment,the documents will be saved in cloud.
* User Data Management
    * User data, including email addresses, is sourced from the users.csv file located in the /opt directory.
    * The application ingests this data and stores it in the database.
    * When a user attempts to create an assignment, the application validates the user against the stored data in the database before allowing the operation.
AWS Integration
* AWS SDK
    * The AWS SDK is used to interact with Amazon Simple Notification Service (SNS) for publishing messages.
Continuous Integration
* GitHub Actions
    * Three GitHub Actions are configured to run for the application upon code commits:
        * Two actions are triggered on pull requests.
        * One action is triggered upon successfully pushing code to the main branch.
AWS Deployment
* Packer Configuration
    * A packer directory has been created to manage the creation of AWS AMIs (Amazon Machine Images) with the web application jar file.
* Systemd Service Configuration
    * A service file has been created for use with systemd, and this file is copied to the AMI.
    * Once the instance is launched, the application will run automatically as a systemd service.
 
 
