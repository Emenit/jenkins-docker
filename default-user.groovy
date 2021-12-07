#!groovy
import jenkins.model.*
import hudson.security.*

def env = System.getenv()

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def users = hudsonRealm.getAllUsers()
def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()
users_s = users.collect { it.toString() }

if (env.JENKINS_USER in users_s) {
    println "Admin user already exists - updating password"

    def user = hudson.model.User.get(env.JENKINS_USER);
    def password = hudson.security.HudsonPrivateSecurityRealm.Details.fromPlainPassword(env.JENKINS_PASS)
    user.addProperty(password)
    user.save()
}
else {
    println "--> creating local admin user"

    hudsonRealm.createAccount(env.JENKINS_USER, env.JENKINS_PASS)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)
}
