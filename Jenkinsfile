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
      withCredentials([
        usernamePassword(credentialsId: "xander-the-harris-jenkins",
                         usernameVariable: 'gcr_user',
                         passwordVariable: 'gcr_pass')
      ]) {
        docker.withRegistry('https://gcr.io', 'xander-the-harris-jenkins') {
          gitbookImage=docker.build('gcr.io/xander-the-harris-jenkins/agent.gitbook')
          gitbookImage.push("v${env.BUILD_NUMBER}")
        }
      }
    }
    stage('build the gitbook') {
      gitbookImage.inside($/
          --label collectd_docker_app=${appNameLabel} \
          --label collectd_docker_task=${taskLabel} \
          --name ${containerName} --memory=2g /$
      ) {
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
