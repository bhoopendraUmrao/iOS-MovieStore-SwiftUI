//
//  InputField.swift
//  MovieStore
//
//  Created by Bhoopendra Umrao on 3/28/23.
//

import SwiftUI

struct InputConfiguration {
    let title: String
    let placeholder: String
    let textContentype: UITextContentType
    let keyboardType: UIKeyboardType
    
    init(title: String, placeholder: String, textContentype: UITextContentType = .name, keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.placeholder = placeholder
        self.textContentype = textContentype
        self.keyboardType = keyboardType
    }
}

struct InputField: View {
    var configuaration: InputConfiguration
    @Binding var value: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(configuaration.title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(configuaration.placeholder, text: $value)
                .textContentType(configuaration.textContentype)
                .keyboardType(configuaration.keyboardType)
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                .background(Color(UIColor.lightGray))
                .cornerRadius(5)
                .foregroundColor(.black)
        }
    }
}

struct SecureInputField: View {
    var configuaration: InputConfiguration
    @Binding var value: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(configuaration.title)
                .font(.caption)
                .foregroundColor(.gray)
            SecureField(configuaration.placeholder, text: $value)
                .textContentType(configuaration.textContentype)
                .keyboardType(configuaration.keyboardType)
                .frame(height: 40)
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                .background(Color(UIColor.lightGray))
                .cornerRadius(5)
                .foregroundColor(.black)
        }
    }
}


struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(configuaration: .init(title: "Name", placeholder: "Name"), value: .constant(""))
    }
}
