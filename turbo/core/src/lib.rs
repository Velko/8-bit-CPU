mod router;
mod devices;
mod gp_register;
mod temp_register;
mod alu;
mod flags;
mod program_counter;
mod control_word;
mod wo_register;
mod memory;

pub use control_word::ControlWord;

#[cfg(test)]
mod test_helpers;

