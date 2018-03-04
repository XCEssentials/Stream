import Foundation

//---

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

//---

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

//---

public
extension ValueStream
{
    /**
     Gives access to exact instace of the object that can be used as target
     when bind this stream directly to a UIControlEvents source - use 'StreamEvent'
     method 'emit', marked intentionally as '@objc' function for such usage.
     */
//    mutating // limit access!
//    func event() -> EventHandlerWrapper
//    {
//        return handlerWrapper
//    }

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

//---

public
typealias StreamOf<T> = ValueStream<T>

//---

public
typealias StreamVoid = ValueStream<Void>
