def docsImage
def appNameLabel = "docker_ci";
def taskLabel = env.JOB_NAME.replaceAll(/\//, "_")
def containerName = "OrientDBDocs.${env.BUILD_NUMBER}"

node("worker") {
  stage('checkout') {
    checkout scm
  }
  stage("building docs for branch  ${env.BRANCH_NAME}") {
    docker.image("orientdb/jenkins-slave-gitbook:6.0.0").inside($/ \
      --label collectd_docker_app=${appNameLabel} \
      --label collectd_docker_task=${taskLabel} \
      --name ${containerName} \
    /$) {
      echo(
        sh(
          label: 'gitbook',
          returnStdout: true,
          script: $/
            rm -rfv _/book/*
            gitbook install --gitbook 3.1.1 .
            gitbook build --gitbook 3.1.1 .
            gitbook pdf --gitbook 3.1.1 . _book/OrientDB-Manual.pdf
          /$,
        )
      )
    }
  }
}
