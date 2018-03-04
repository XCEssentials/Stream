import Foundation

import XCEViewEvents

//---

public
extension PendingEventsOperation
{
    func plug<T>(into stream: ValueStream<T>)
    {
        removeAllHandlers(of: stream.wrapper)
        add(#selector(stream.wrapper.submit), of: stream.wrapper)
    }

    func unplug<T>(from stream: ValueStream<T>)
    {
        removeAllHandlers(of: stream.wrapper)
    }
}

//---

public
extension PendingRecognizerOperation
{
    func addRecognizer<T>(
        pluggedInto stream: ValueStream<T>,
        configuration: ((Recognizer) -> Void)? = nil
        )
    {
        addRecognizer(
            with: #selector(stream.wrapper.submit),
            of: stream.wrapper,
            configuration: configuration ?? { _ in }
        )
    }
}

// MARK: - Custom operators

public
func >> <T>(
    eventsOperation: PendingEventsOperation,
    stream: ValueStream<T>
    )
{
    eventsOperation.plug(into: stream)
}

public
func >> <R, T>(
    recognizerOperation: PendingRecognizerOperation<R>,
    stream: ValueStream<T>
    )
{
    recognizerOperation.addRecognizer(pluggedInto: stream)
}
