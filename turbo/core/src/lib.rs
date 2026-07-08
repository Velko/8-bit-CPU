mod router;
mod devices;
mod gp_register;
mod temp_register;
mod alu;
mod flags;
mod program_counter;

#[cfg(test)]
mod test_helpers;

type ControlWord = u32;
