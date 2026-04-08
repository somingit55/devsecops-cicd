pipeline {
    agent any
    environment {
        SONAR_HOME = tool "Sonar"
        // Jenkins me stored secret text ID 'NVD_API_KEY' ko read kar raha hai
        DEPENDENCY_CHECK_NVD_API_KEY = credentials('NVD_API_KEY')
    }
    
    stages {
        stage("Clone Code from GitHub") {
            steps {
                echo "Cloning repository from GitHub..."
                git url: "https://github.com/somingit55/devsecops-cicd.git", branch: "main"
            }
        }

        stage("SonarQube Quality Analysis") {
            steps {
                echo "Running SonarQube Quality Analysis..."
                withSonarQubeEnv("Sonar") {
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=devsecops -Dsonar.projectKey=devsecops -Dsonar.host.url=$SONAR_HOST_URL"
                }
            }
        }

        stage("OWASP Dependency Check") {
            steps {
                echo "Running OWASP Dependency Check..."
                withEnv(["DEPENDENCY_CHECK_NVD_API_KEY=$DEPENDENCY_CHECK_NVD_API_KEY"]) {
                    // Explicit output folder diya hai jisse publisher report parse kar sake
                    dependencyCheck additionalArguments: '--scan ./ --format XML --out ./dependency-check-report', odcInstallation: 'OWASP'
                    dependencyCheckPublisher pattern: 'dependency-check-report/dependency-check-report.xml'
                }
            }
        }

        stage("Sonar Quality Gate Scan") {
            steps {
                echo "Waiting for SonarQube Quality Gate..."
                timeout(time: 2, unit: "MINUTES") {
                    // Agar fail ho bhi jaye, pipeline continue karega
                    waitForQualityGate abortPipeline: false
                }
            }
        }

        stage("Trivy File System Scan") {
            steps {
                echo "Running Trivy File System Scan..."
                // Agar secret scanning slow ho to later '--scanners vuln' option add kar sakte ho
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }

        stage("Run Frontend Container") {
            steps {
                echo "Building and Running Frontend Container..."
                // Purana container hata do
                sh 'docker stop frontend-container || true'
                sh 'docker rm frontend-container || true'
                // Nayi image build karo
                sh 'docker build -t frontend-image:latest ./frontend'
                // Container run karo with bind mount (code changes turant reflect honge)
                sh 'docker run -v ${WORKSPACE}/frontend:/app -p 3000:3000 --name frontend-container -d frontend-image:latest'
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
