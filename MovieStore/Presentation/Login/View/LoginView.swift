//
//  LoginView.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/24/23.
//

import SwiftUI

struct LoginView<ViewModel>: View where ViewModel: LoginViewModel {
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var showingAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appConfigurator: AppConfigurationContainer
    @State var loginViewModel: ViewModel
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Image(systemName: "person")
                    .imageScale(.large)
                    .padding(50)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: colorScheme == .dark ? .white : .black, radius: 5)
                    .tint(colorScheme == .dark ? .white : .black)
                ZStack(alignment: .center) {
                    VStack( alignment: .center, spacing: 4) {
                        Group {
                            Text("LOGIN")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top, 50)
                            
                            Text("Sign in to continue.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            InputField(configuaration: .init(title: "Email", placeholder: "Email", textContentype: .emailAddress, keyboardType: .emailAddress), value: $userName)
                            
                            SecureInputField(configuaration: .init(title: "Password", placeholder: "Password", textContentype: .password), value: $password)
                        }
                        .padding(.horizontal, 60)
                        Button {
                            Task {
                                await self.requestLogin()
                            }
                        } label: {
                            Text("Log In")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(height: 40)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(.horizontal, 110)
                                .background(colorScheme == .dark ? .black : .white)
                                .cornerRadius(5)
                        }
                        .padding(20)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error!"), message: Text("Enter username/password"), dismissButton: .default(Text("Got it!")))
                        }
                        
                        Text("Forgot Password?")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 16)
                        Text("Sign Up")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 16)
                            .padding(.bottom, 60)
                    }
                    
                }
                .background(colorScheme == .dark ? .white : .black)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .roundedCorner(100, corners: [.topRight])
                .padding(.top, 50)
            }
            .padding(.top, 100)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
        
        .ignoresSafeArea()
        .keyboardAdaptive()
    }
    
    private func requestLogin() async {
        guard !userName.isEmpty && !password.isEmpty else {
            showingAlert.toggle()
            return
        }
        let loggedInToken = await self.loginViewModel.requestLogin(userName: userName,
                                                                      password: password)
        
        await MainActor.run { [loggedInToken] in
            if let token = loggedInToken {
                appConfigurator.setLoggedInToken(token.token, expireationDate: token.expireAt)
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigurationContainer().makeLoginView()
    }
}
