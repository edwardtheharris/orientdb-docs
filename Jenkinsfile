def appNameLabel = "docker_ci"
def taskLabel = env.JOB_NAME
def containerName="docs-${env.BUILD_NUMBER}"
def gitbookImage

ansiColor() {
  node("worker") {
    stage('checkout') {
      checkout scm
    }
    stage("building docs for branch  ${env.BRANCH_NAME}") {
      gitbookImage=docker.build('orientdb/jenkins-slave-gitbook:6.0.0')
      gitbookImage.inside($/
          --label collectd_docker_app=${appNameLabel} \
          --label collectd_docker_task=${taskLabel} \
          --name ${containerName} --memory=2g
        /$
      ) {
        checkout scm
        echo(
          sh(label: 'gitbook',
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
      // if (!env.BRANCH_NAME.startsWith("PR-")) {
      //   docker.image(
      //     "orientdb/jenkins-slave-rsync:20160503").inside($/
      //       --label collectd_docker_app=${appNameLabel} \
      //       --label collectd_docker_task=${taskLabel} \
      //       --name ${containerName}  \
      //       --memory=2g \
      //       -v /home/orient:/home/jenkins:ro
      //     /$
      //   ) {
      //       echo(
      //         sh(label: 'rsync',
      //           script: $/
      //                     rsync -ravh --stats _book/  -e ${env.RSYNC_DOC}/${env.BRANCH_NAME}/
      //                   /$,
      //           returnStdout: true
      //         )
      //     )
      //   }
      // } else {
      //   echo("it's a PR, no sync required")
      // }
    }
  }
}
