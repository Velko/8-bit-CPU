#include "fixtures.h"
#include "devices.h"

BusStateFixture::BusStateFixture()
{
    main_bus = 0;
    address_bus = 0;
    flags_bus = 0;
    alu_arg_l_bus = 0;
    alu_arg_r_bus = 0;
}