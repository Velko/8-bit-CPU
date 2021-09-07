#ifndef __AVR__

#include "arduino_string.h"

String::String(std::string &&src)
    : str{src}
{
}

bool String::startsWith(const char *s) const
{
    return str.find(s) == 0;
}

bool String::equals(const char *s) const
{
    return str == s;
}

String String::substring(size_t from) const
{
    return String(str.substr(from));
}

#endif