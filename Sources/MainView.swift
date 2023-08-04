import SwiftUI
import Auth0
import SimpleKeychain

struct MainView: View {
    @State var profile = Profile.empty
    @State var loggedIn = false
    @State var credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    @State var rtAvailable = false
    
    
    var body: some View {
        if loggedIn {
            VStack {
                ProfileView(profile: self.$profile)
                Button("Logout", action: self.logout)
            }.onOpenURL { url in
                WebAuthentication.resume(with: url)
            }
        } else {
            VStack {
                HeroView()
                Button("Login", action: self.login)
            }.onAppear {

                
                if (credentialsManager.hasValid() == false && A0SimpleKeychain().hasValue(forKey: "rtExists"))
                {
                    credentialsManager.enableBiometrics(withTitle: "Touch or enter passcode to Login")
                }
                
                credentialsManager.credentials { result in
                    switch result {
                    case .success(let credentials):
                        self.profile = Profile.from(credentials.idToken)
                        A0SimpleKeychain().setString("Y", forKey: "rtExists")
                        loggedIn = true
                    case .failure(let error):
                        loggedIn = false
                        print("Failed with: \(error)")
                    }
                }
                

            }.onOpenURL { url in
                WebAuthentication.resume(with: url)
            }
        }
    }
    
}

extension MainView {
    
     func login() {

        Auth0
             .webAuth()
            .provider(WebAuthentication.safariProvider())
            .audience("organise")
            .parameters(["login_hint" : "pushp.abrol@gmail.com"])
            .scope("openid profile email offline_access read:calendar")
            .start { result in
                switch result {
                case .success(let credentials):
                    self.loggedIn = credentialsManager.store(credentials: credentials)
                    self.profile = Profile.from(credentials.idToken)
                    if(credentials.refreshToken != nil) {rtAvailable = true}
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }

    func logout() {
       A0SimpleKeychain().clearAll()
        _ = credentialsManager.clear()
        Auth0
            .webAuth()
            .provider(WebAuthentication.safariProvider())
            .clearSession(federated: true, callback: { result in
                switch result {
                case .success:
                    
                    self.loggedIn = false
                    
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            })
            
    }
    
}
