#ifndef GSTL_INITIALIZER_LIST_H
#define GSTL_INITIALIZER_LIST_H

#include <stddef.h>

/* Since AVR / Arduino compiler does not provide C++ Standard Library, but compiler still
   relies on that, we need to provide the class by ourselves.

    Copied from GreenSTL - an unpublished project by yours truly.
*/

namespace std
{
    template<typename T>
    class initializer_list
    {
    public:
        typedef T           value_type;
        typedef T&          reference;
        typedef const T&    const_reference;
        typedef size_t      size_type;
        typedef const T*    iterator;
        typedef const T*    const_iterator;

        constexpr initializer_list() noexcept
            : _m_array{nullptr}, _m_size{0}
        {}

        constexpr size_type size() const noexcept
        {
            return _m_size;
        }

        constexpr iterator begin() const noexcept
        {
            return _m_array;
        }

        constexpr iterator end() const noexcept
        {
            return _m_array + _m_size;
        }
    private:
        iterator _m_array;
        size_type _m_size;

    };

    template<typename T>
    constexpr typename initializer_list<T>::iterator begin(initializer_list<T> il) noexcept
    {
        return il.begin();
    }

    template<typename T>
    constexpr typename initializer_list<T>::iterator end(initializer_list<T> il) noexcept
    {
        return il.end();
    }
}

#endif /* GSTL_INITIALIZER_LIST_H */
