import SwiftUI
import BetterSafariView
struct ProfileView: View {
    @Binding var profile: Profile
    
    @State private var presentingSafariView = false

    var body: some View {
        List {
            Section(header: ProfileHeader(picture: profile.picture)) {
                ProfileCell(key: "ID", value: profile.id)
                ProfileCell(key: "Name", value: profile.name)
                ProfileCell(key: "Email", value: profile.email)
                ProfileCell(key: "Email verified?", value: profile.emailVerified)
                ProfileCell(key: "Updated at", value: profile.updatedAt)
//                Button(action: {
//                            self.presentingSafariView = true
//                        }) {
//                            Text("Launch Web!")
//                        }
//                        .safariView(isPresented: $presentingSafariView) {
//                            SafariView(
//                                url: URL(string: "https://oidc-sp.desmaximus.com/profile")!,
//                                configuration: SafariView.Configuration(
//                                    entersReaderIfAvailable: false,
//                                    barCollapsingEnabled: true
//                                )
//                            )
//                            .preferredBarAccentColor(.clear)
//                            .preferredControlAccentColor(.accentColor)
//                            .dismissButtonStyle(.done)
//                        }
                    }

            }
        }
    }

