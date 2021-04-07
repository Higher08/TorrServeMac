//
//  OnView+View.swift
//  TorrServe-SwiftUI
//
//  Created by Dmytro on 05.04.2021.
//

import Foundation

import SwiftUI


extension View {
    func onView(added: @escaping (NSUIView) -> Void) -> some View {
        ViewAccessor(onViewAdded: added) { self }
    }
}

struct ViewAccessor<Content>: NSUIViewRepresentable where Content: View {
    var onView: (NSUIView) -> Void
    var viewBuilder: () -> Content
    typealias NSUIViewType = ViewAccessorHosting<Content>
    
    init(onViewAdded: @escaping (NSUIView) -> Void, @ViewBuilder viewBuilder: @escaping () -> Content) {
        self.onView = onViewAdded
        self.viewBuilder = viewBuilder
    }
    func makeNSView(context: Context) -> ViewAccessorHosting<Content> {
        return ViewAccessorHosting(onView: onView, rootView: self.viewBuilder())
    }
    
    func updateNSView(_ nsView: ViewAccessorHosting<Content>, context: Context) {
        nsView.rootView = self.viewBuilder()
    }
}

class ViewAccessorHosting<Content>: NSUIHostingView<Content> where Content: View {
    var onView: ((NSUIView) -> Void)
    
    init(onView: @escaping (NSUIView) -> Void, rootView: Content) {
        self.onView = onView
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: NSUIView) {
        super.didAddSubview(subview)
        onView(subview)
    }
}

import AppKit

public typealias NSUIView = NSView
public typealias NSUIHostingView = NSHostingView
public typealias NSUIScrollView = NSScrollView
public typealias NSUILabel = NSTextField
public typealias NSUIFont = NSFont
public typealias NSUIColor = NSColor
public typealias NSUIWindow = NSWindow

public protocol NSUIViewRepresentable: NSViewRepresentable {
    typealias NSUIViewType = NSViewType
    func makeView(context: Self.Context) -> Self.NSUIViewType
    func updateView(_ view: Self.NSUIViewType, context: Self.Context)
}

public extension NSUIViewRepresentable {
    func makeView(context: Self.Context) -> Self.NSUIViewType {
        return makeNSView(context: context)
    }
    
    func updateView(_ view: Self.NSUIViewType, context: Self.Context) {
        updateNSView(view, context: context)
    }
}
