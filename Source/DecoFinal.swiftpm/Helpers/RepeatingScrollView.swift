//
//  InfiniteScroll.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//

import SwiftUI

struct RepeatingScrollView<Content: View>: View {
    var spacing: CGFloat = 15
    @ViewBuilder var content: Content
    
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let viewSize = $0.size
            ScrollView(.horizontal) {
                HStack(spacing: spacing){
                    Group(subviews: content) { collection in
                        HStack{
                            ForEach(collection) { view in
                                view
                            }
                        }
                        .onGeometryChange(for: CGSize.self) { proxy in
                            return proxy.size
                        } action: { newValue in
                            contentSize = CGSize(width: newValue.width + spacing,
                                                 height: newValue.height
                            )
                        }

                        // repeated content
                        
                        let avgWidth = contentSize.width / CGFloat(collection.count)
                        let repeatingCount = contentSize.width > 0 ? Int((viewSize.width / avgWidth).rounded()) + 1 : 1
                        
                        HStack(spacing: spacing) {
                            ForEach(0..<repeatingCount, id: \.self){ i in
                                let repeatedView = Array(collection)[i % collection.count]
                                
                                repeatedView
                            }
                        }
                        
                    }
                }
                .background(RepeatingScrollHelper(decelerationRate: .constant(.fast), contentSize: $contentSize))
            }
            .scrollClipDisabled()
        }
    }
}


fileprivate struct RepeatingScrollHelper: UIViewRepresentable{
    @Binding var decelerationRate: UIScrollView.DecelerationRate
    @Binding var contentSize: CGSize
    
    func makeCoordinator() -> Coordinator {
        Coordinator.init(decelerationRate: decelerationRate, contentSize: contentSize)
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.decelerationRate = decelerationRate
        context.coordinator.contentSize = contentSize
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let scrollView = view.scrollView{
                context.coordinator.defaultDelegate = scrollView.delegate
                scrollView.decelerationRate = decelerationRate
                scrollView.delegate = context.coordinator
            }
        }
        
        return view
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate{
        var decelerationRate: UIScrollView.DecelerationRate
        var contentSize: CGSize
        init(decelerationRate: UIScrollView.DecelerationRate, contentSize: CGSize) {
            self.decelerationRate = decelerationRate
            self.contentSize = contentSize
        }
        
        weak var defaultDelegate: UIScrollViewDelegate?
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            scrollView.decelerationRate = decelerationRate
            
            let minX = scrollView.contentOffset.x
            
            if minX > contentSize.width{
                scrollView.contentOffset.x -= contentSize.width
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += contentSize.width
            }
            
            defaultDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        // default callbacks
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            defaultDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewDidEndDecelerating?(scrollView)
        }
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            defaultDelegate?.scrollViewWillBeginDragging?(scrollView)
        }
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            defaultDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
        
    }
}

extension UIView{
    var scrollView: UIScrollView?{
        if let superview, superview is UIScrollView{
            return superview as? UIScrollView
        }
        return superview?.scrollView
    }
}
