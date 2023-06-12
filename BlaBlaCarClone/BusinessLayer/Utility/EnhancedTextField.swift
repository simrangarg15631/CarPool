//
//  EnhancedTextField.swift
//  BlaBlaCarClone
//
//  Created by Saheem Hussain on 12/06/23.
//

import Foundation
import UIKit
import SwiftUI

struct EnhancedTextField: UIViewRepresentable {
  let placeholder: String // text field placeholder
  @Binding var text: String // input binding
  let onBackspace: (Bool) -> Void // true if backspace on empty input

  func makeCoordinator() -> EnhancedTextFieldCoordinator {
    EnhancedTextFieldCoordinator(textBinding: $text)
  }

  func makeUIView(context: Context) -> EnhancedUITextField {
    let view = EnhancedUITextField()
    view.placeholder = placeholder
    view.delegate = context.coordinator
    return view
  }

  func updateUIView(_ uiView: EnhancedUITextField, context: Context) {
    uiView.text = text
    uiView.onBackspace = onBackspace
  }

  // custom UITextField subclass that detects backspace events
  class EnhancedUITextField: UITextField {
    var onBackspace: ((Bool) -> Void)?

    override init(frame: CGRect) {
      onBackspace = nil
      super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
      fatalError()
    }

    override func deleteBackward() {
      onBackspace?(text?.isEmpty == true)
      super.deleteBackward()
    }
  }
}

// the coordinator is here to allow for mapping text to the
// binding using the delegate methods
class EnhancedTextFieldCoordinator: NSObject {
  let textBinding: Binding<String>

  init(textBinding: Binding<String>) {
    self.textBinding = textBinding
  }
}

extension EnhancedTextFieldCoordinator: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    textBinding.wrappedValue = textField.text ?? ""
    return true
  }
}
