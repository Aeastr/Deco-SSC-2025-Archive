//
//  RichTextEditor.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

// this allows support for adaptive image glyphs (like genmojis) by setting supportsAdaptiveImageGlyph to true

struct RichTextEditor: UIViewRepresentable {
    @Binding var attributedText: NSAttributedString

    @Binding var isFocused: Bool
    var fontSize: CGFloat
    var onEditingChanged: ((Bool) -> Void)? = nil
    var onCommit: (() -> Void)? = nil

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            print("textViewDidBeginEditing")
            parent.onEditingChanged?(true)
            DispatchQueue.main.async {
                self.parent.isFocused = true
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            print("textViewDidEndEditing")
            parent.onEditingChanged?(false)
            parent.onCommit?()
            DispatchQueue.main.async {
                self.parent.isFocused = false
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            print("textViewDidChange")
            if textView.attributedText != parent.attributedText {
                parent.attributedText = textView.attributedText
            }
        }
        
        func textView(_ textView: UITextView,
                      shouldChangeTextIn range: NSRange,
                      replacementText text: String) -> Bool {
            let currentText = textView.text ?? ""
            guard let textRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: textRange, with: text)
            return updatedText.count <= 10
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.supportsAdaptiveImageGlyph = true
        textView.textAlignment = .center
        textView.attributedText = attributedText
        textView.typingAttributes = defaultTypingAttributes()
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12,
                                                   bottom: 12, right: 12)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.typingAttributes = defaultTypingAttributes()

        if uiView.attributedText != attributedText {
            uiView.attributedText = attributedText
        }
        
        if isFocused, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused, uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }

    func defaultTypingAttributes() -> [NSAttributedString.Key: Any] {
        let font = UIFont.systemFont(ofSize: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return [
            .font: font,
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle
        ]
    }
}



class EmojiTextView: UITextView {
    override var textInputContextIdentifier: String? { "" }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return super.textInputMode
    }
    
    override var intrinsicContentSize: CGSize {
        return self.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
    }
}
