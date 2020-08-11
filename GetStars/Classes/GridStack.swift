//
//  GridStack.swift
//  GetStars
//
//  Created by Alejandro Miranda on 11/08/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import SwiftUI

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct GridCalculator {
    typealias GridDefinition = (
        columnWidth: CGFloat,
        columnCount: Int
    )
    
    func calculate(
        availableWidth: CGFloat,
        minimumCellWidth: CGFloat,
        cellSpacing: CGFloat
    ) -> GridDefinition {
        /**
         * 1. Subtract the cell spacing once from all the available width
         * 2. Add the cell spacing to each cell Width
         * 3. See how many fit and round that down (by producing an `Int`)
         */
        let columnsThatFit = Int((availableWidth - cellSpacing) / (minimumCellWidth + cellSpacing))
        let columnCount = max(1, columnsThatFit)
        let remainingWidth = availableWidth - totalSpacingFor(columnCount: columnCount, cellSpacing: cellSpacing)
        
        return (
            columnWidth: remainingWidth / CGFloat(columnCount),
            columnCount: columnCount
        )
    }
    
    private func totalSpacingFor(columnCount: Int, cellSpacing: CGFloat) -> CGFloat {
        // There is a total of `columnCount + 1` spacers
        return CGFloat((columnCount + 1)) * cellSpacing
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct GridStack<Content>: View where Content: View {
    private let minCellWidth: CGFloat
    private let spacing: CGFloat
    private let numItems: Int
    private let alignment: HorizontalAlignment
    private let content: (Int, CGFloat) -> Content
    private let gridCalculator = GridCalculator()
    
    public init(
        minCellWidth: CGFloat,
        spacing: CGFloat,
        numItems: Int,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping (Int, CGFloat) -> Content
    ) {
        self.minCellWidth = minCellWidth
        self.spacing = spacing
        self.numItems = numItems
        self.alignment = alignment
        self.content = content
    }
    
    var items: [Int] {
        Array(0..<numItems).map { $0 }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            InnerGrid(
                width: geometry.size.width,
                spacing: self.spacing,
                items: self.items,
                alignment: self.alignment,
                content: self.content,
                gridDefinition: self.gridCalculator.calculate(
                    availableWidth: geometry.size.width,
                    minimumCellWidth: self.minCellWidth,
                    cellSpacing: self.spacing
                )
            )
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
private struct InnerGrid<Content>: View where Content: View {
    
    private let width: CGFloat
    private let spacing: CGFloat
    private let rows: [[Int]]
    private let alignment: HorizontalAlignment
    private let content: (Int, CGFloat) -> Content
    private let columnWidth: CGFloat
    
    init(
        width: CGFloat,
        spacing: CGFloat,
        items: [Int],
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping (Int, CGFloat) -> Content,
        gridDefinition: GridCalculator.GridDefinition
    ) {
        self.width = width
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
        self.columnWidth = gridDefinition.columnWidth
        rows = items.chunked(into: gridDefinition.columnCount)
    }
    
    var body : some View {
        ScrollView(.vertical) {
            VStack(alignment: alignment, spacing: spacing) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: self.spacing) {
                        ForEach(row, id: \.self) { item in
                            // Pass the index and the cell width to the content
                            self.content(item, self.columnWidth)
                                .frame(width: self.columnWidth)
                        }
                    }.padding(.horizontal, self.spacing)
                }
            }
            .padding(.top, spacing)
            .frame(width: width)
        }
    }
}
