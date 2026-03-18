import jenkins.model.*
import hudson.security.*

String username = 'admin-recovery'
String password = 'ZM7fDYh8TrGNvcWI6mAV!Aa1'

Jenkins instance = Jenkins.get()

def realm = instance.getSecurityRealm()
if (!(realm instanceof HudsonPrivateSecurityRealm)) {
  realm = new HudsonPrivateSecurityRealm(false)
  instance.setSecurityRealm(realm)
}

if (realm.getUser(username) == null) {
  realm.createAccount(username, password)
}

def strategy = instance.getAuthorizationStrategy()
if (!(strategy instanceof GlobalMatrixAuthorizationStrategy)) {
  strategy = new GlobalMatrixAuthorizationStrategy()
}
strategy.add(Jenkins.ADMINISTER, username)
instance.setAuthorizationStrategy(strategy)
instance.save()
println("Recovery admin ensured: " + username)