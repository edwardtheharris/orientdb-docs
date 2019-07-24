
node("worker") {
  stage('clean') {
    deleteDir()
  }
  stage('checkout') {
    checkout scm
  }
  stage("building docs for branch  ${env.BRANCH_NAME}") {
    def appNameLabel = "docker_ci";
    def taskLabel = env.JOB_NAME.replaceAll(/\//, "_")
  }
  stage("run ci container") {
    docker.image(
      "orientdb/jenkins-slave-gitbook:6.0.0").inside($/
        --label collectd_docker_app=${appNameLabel} --label collectd_docker_task=${taskLabel}
       --name ${containerName} --memory=2g
      /$) {
        echo(
          sh(label: 'build',
             script: $/
                        rm -rf _/book/*
                        gitbook install --gitbook 3.1.1 .
                        gitbook build --gitbook 3.1.1 .
                        gitbook pdf --gitbook 3.1.1 . _book/OrientDB-Manual.pdf
                     /$,
             returnStdout: true
          )
        )
      }
      if (!env.BRANCH_NAME.startsWith("PR-")) {
        docker.image(
          "orientdb/jenkins-slave-rsync:20160503").inside($/
              --label collectd_docker_app=${appNameLabel} --label collectd_docker_task=${taskLabel}
               --name ${containerName}  --memory=2g -v /home/orient:/home/jenkins:ro
            /$) {
           sh($/
             rsync -ravh --stats _book/  -e ${env.RSYNC_DOC}/${env.BRANCH_NAME}/
           /$)
        }
      } else {
          echo "it's a PR, no sync required"
      }
    }
  }
}
