#ifndef __AVR__

#include "arduino_string.h"
#include <algorithm>

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

void String::trim()
{
    str.erase(str.begin(), std::find_if(str.begin(), str.end(), [](unsigned char ch) {
        return !std::isspace(ch);
    }));

    str.erase(std::find_if(str.rbegin(), str.rend(), [](unsigned char ch) {
        return !std::isspace(ch);
    }).base(), str.end());
}

#endif
