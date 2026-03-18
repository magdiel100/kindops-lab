import jenkins.model.*
import hudson.security.*
import hudson.model.User

String username = "admin"
String password = "admin"

Jenkins instance = Jenkins.get()
def realm = instance.getSecurityRealm()
if (!(realm instanceof HudsonPrivateSecurityRealm)) {
  realm = new HudsonPrivateSecurityRealm(false)
  instance.setSecurityRealm(realm)
}

User u = realm.getUser(username)
if (u == null) {
  u = realm.createAccount(username, password)
} else {
  u.addProperty(HudsonPrivateSecurityRealm.Details.fromPlainPassword(password))
  u.save()
}

def strategy = instance.getAuthorizationStrategy()
if (!(strategy instanceof GlobalMatrixAuthorizationStrategy)) {
  strategy = new GlobalMatrixAuthorizationStrategy()
}
strategy.add(Jenkins.ADMINISTER, username)
instance.setAuthorizationStrategy(strategy)
instance.save()
println("OK: admin password reset and admin role ensured")