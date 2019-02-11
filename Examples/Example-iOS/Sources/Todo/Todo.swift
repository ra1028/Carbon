import Foundation

struct Todo: Equatable {
    typealias ID = UUID

    var id: ID
    var text: String
}
