pipeline {
    agent any
    environment {
        SONAR_HOME = tool "Sonar"
    }
    
    stages {
        stage("Clone Code from GitHub") {
            steps {
                echo "Cloning repository from GitHub..."
                git url: "https://github.com/somingit55/devsecops-cicd.git", branch: "main"
            }
        }

      //  stage("SonarQube Quality Analysis") {
         //   steps {
                // echo "Running SonarQube Quality Analysis..."
                // withSonarQubeEnv("Sonar") {
                //     sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=devsecops -Dsonar.projectKey=devsecops -Dsonar.host.url=$SONAR_HOST_URL"
                // }
          //  }
       // }

       // stage("OWASP Dependency Check") {
          //  steps {
                // echo "Running OWASP Dependency Check..."
                // dependencyCheck additionalArguments: '--scan ./ --format XML --out .', odcInstallation: 'OWASP'
                // dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
          //  }
       // }

        stage("Trivy File System Scan") {
            steps {
                echo "Running Trivy File System Scan..."
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }

        stage("Deploy using Docker Compose") {
            steps {
                echo "Deploying application using Docker Compose..."
                sh "docker-compose up -d"
            }
        }
    }
}
