//
//  Created by Wojciech Chojnacki on 02/06/2021.
//

import Foundation

import XCTest
@testable import NotionSwift

// swiftlint:disable line_length
final class PageCreateRequestTests: XCTestCase {
    func test_propertiesEncoding_case01() throws {
        let parentId = Page.Identifier("12345")
        let given = PageCreateRequest(
            parent: .page(parentId),
            properties: ["title": .init(type: .title([.init(string: "Lorem ipsum")]))],
            children: []
        )

        let result = try encodeToJson(given)

        XCTAssertEqual(result, #"{"children":[],"parent":{"page_id":"12345"},"properties":{"title":{"title":[{"text":{"content":"Lorem ipsum"}}]}}}"#)
    }

    func test_propertiesAndChildrenEncoding_case01() throws {
        let parentId = Page.Identifier("12345")
        let children: [WriteBlock] = [
            .init(type: .paragraph(.init(text: [
                .init(string: "Lorem ipsum dolor sit amet, ")
            ])))
        ]
        let given = PageCreateRequest(
            parent: .page(parentId),
            properties: ["title": .init(type: .title([.init(string: "Lorem ipsum")]))],
            children: children
        )

        let result = try encodeToJson(given)

        XCTAssertEqual(result, #"{"children":[{"has_children":false,"object":"block","paragraph":{"text":[{"text":{"content":"Lorem ipsum dolor sit amet, "}}]},"type":"paragraph"}],"parent":{"page_id":"12345"},"properties":{"title":{"title":[{"text":{"content":"Lorem ipsum"}}]}}}"#)
    }

    func test_childrenEncoding_case01() throws {
        let parentId = Page.Identifier("12345")
        let children: [WriteBlock] = [
            .init(type: .paragraph(.init(text: [
                .init(string: "Lorem ipsum dolor sit amet, ")
            ])))
        ]

        let given = PageCreateRequest(
            parent: .page(parentId),
            properties: [:],
            children: children
        )

        let result = try encodeToJson(given)

        XCTAssertEqual(result, #"{"children":[{"has_children":false,"object":"block","paragraph":{"text":[{"text":{"content":"Lorem ipsum dolor sit amet, "}}]},"type":"paragraph"}],"parent":{"page_id":"12345"},"properties":{}}"#)
    }
}
