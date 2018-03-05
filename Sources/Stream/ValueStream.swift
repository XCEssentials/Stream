/*

 MIT License

 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

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
