pipeline {
    agent any
    tools {
        // Install the Maven version configured as "Apache Maven 3.8.5" and add it to the path.
        // manage jenkins >> global tool config >> maven installation >> give name and path
        maven 'Apache Maven 3.8.5'
    }

    stages {
        stage('Clean WS') {
            steps {
            echo "Cleaning WORKSPACE"
            sh 'rm -rf *; pwd ; ls -ltrh'
            }
        }

        stage('Git Checkout') {
              steps {
                script {
                  echo "listinng SCM details"
                  def GIT_URL = "https://github.com/messi10hitu/spring-boot-hello-world.git"
                  def BRANCH_NAME = "master"
                  echo "giturl is ${GIT_URL} and branch is ${BRANCH_NAME}"
                //   adding git to read the code
                  git branch: "${BRANCH_NAME}",
                //       credentialsId: "${GITCRED_ID}",
                      url: "${GIT_URL}"
                  sh 'echo "listing Current Directory" && ls -ltrh; pwd'

                //   also we can use the pipeline syntax to read code from git
                // pipeline syntax >> checkout version control from sample steps >> git details >> generate pipeline script
                // checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/messi10hitu/spring-boot-hello-world.git']]])
                }
              }

        }
        stage('Build Maven') {
            steps {
                echo "Building project"
                echo "hello World!.."
                sh "mvn -X -version"
                // sh "mvn clean install"
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
                // sh "mvn -B -DskipTests clean package"
                }
            }

        //  stage('SonarQube analysis') {
        //      steps {
        //     withSonarQubeEnv(installationName: 'SonarQube', credentialsId: 'sonarpwd')
        //         {
        //         //  sh "mvn sonar:sonar"
        //         sh "mvn -T 20C -U sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.login=admin -Dsonar.password=password -Dsonar.language=java -Dmaven.test.skip"
        //         }
        //     }
        //  }


         stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: 'nexus3',
                            protocol: 'http',
                            nexusUrl: 'localhost:8081',
                            groupId: 'pom.org.springframework.boot',
                            version: 'pom.1.0.1-SNAPSHOT',
                            repository: 'maven-central-repository',
                            credentialsId: 'Nexus-cred',
                            artifacts: [
                                [artifactId: 'pom.hello-world',
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: 'pom.hello-world',
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
         }


        // stage('Build Docker Image') {
        //     steps {
        //         // may get command not found issue to resolve this we need to make some changes follow below url
        //         // https://harshityadav95.medium.com/how-to-setup-docker-in-jenkins-on-mac-c45fe02f91c5
        //         echo "building the docker image"
        //         sh 'docker build -t messi10hitu/hello-world .'
        //         }
        //     }

        // stage('Login Docker and Push') {
        //     steps {
        //         echo "checking the credentials and docker login"
        //         withCredentials([string(credentialsId: 'dockerpwd', variable: 'dockerhubpwd')])
        //         {
        //         sh '''
        //         docker login -u messi10hitu -p ${dockerhubpwd}
        //         echo Pushing the docker image
        //         docker push messi10hitu/hello-world
        //         '''
        //         }
        //         }
        //     }
        }

    }