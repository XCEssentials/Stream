import Foundation

// MARK: - Wrapper

class Wrapper<T>
{
    var handler: ((T) -> Void)?

    /**
     Special helper for direct connection with target/action sources of
     UIControlEvents-based notifications (UIButton, UITextField, etc.).
     These kind of notifications always expect to be connected to handlers
     that take no parameters or single parameter which is the sender object.
     In a special case, a 'Void' value '()' should be valid for this declaration
     as well.
     */
    @objc
    func submit(_ payload: Any)
    {
        // https://developer.apple.com/documentation/uikit/uicontrol#1943645

        if
            let typedPayload = () as? T // T is Void
        {
            handler?(typedPayload)
        }
        else
        if
            let typedPayload = payload as? T
        {
            handler?(typedPayload)
        }
    }
}

// MARK: - Stream

public
struct ValueStream<T>
{
    let wrapper = Wrapper<T>()

    //---

    public
    init(with handler: ((T) -> Void)? = nil)
    {
        wrapper.handler = handler
    }
}

// MARK: - Stream management

public
extension ValueStream
{
    /**
     Defines handler that's going to be executed when the stream emits an event.
     */
    func bind(with handler: @escaping (T) -> Void)
    {
        wrapper.handler = handler
    }

    /**
     This function is 'mutating' only to allow limit usage of this func
     to the local scope by marking property of this type as
     'private(set)'.
     */
    mutating
    func submit(_ payload: T)
    {
        wrapper.handler?(payload)
    }
}

// MARK: - Convenience aliases

public
typealias StreamOf<T> = ValueStream<T>

public
typealias StreamVoid = ValueStream<Void>

// MARK: - Custom operators

public
func >> <T>(
    stream: ValueStream<T>,
    handler: @escaping (T) -> Void
    )
{
    stream.bind(with: handler)
}
