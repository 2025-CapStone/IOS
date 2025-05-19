import Foundation

final class RepositoryTask: Cancellable {
    private(set) var isCancelled = false
    var networkTask: NetworkCancellable?

    func cancel() {
        isCancelled = true
        networkTask?.cancel()
    }
}
