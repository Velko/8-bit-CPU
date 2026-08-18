pub struct BusSourcesPart {
    pub main_bus_sources: BusSource,
    pub address_bus_sources: BusSource,
    pub alu_l_sources: BusSource,
    pub alu_r_sources: BusSource,
    pub flags_sources: BusSource,
}

pub struct BusSource {
    enum_name: String,
    member_names: Vec<String>,
}

impl BusSource {
    pub fn new(name: &str) -> Self {
        Self {
            enum_name: name.to_owned(),
            member_names: Vec::new(),
        }
    }

    pub fn push(&mut self, member_name: &str) {
        self.member_names.push(member_name.to_owned());
    }

    pub fn emit_struct(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum {} {{", self.enum_name)?;
        for source in self.member_names.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)
    }

    pub fn emit_get_value(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        writeln!(writer, "        match source {{")?;
        for device in self.member_names.iter() {
            writeln!(writer, "            {}::{} => self.{}.get_value(bus_values),", self.enum_name, device, device)?;
        }
        writeln!(writer, "        }}")
    }
}

impl BusSourcesPart {
    pub fn new() -> Self {
        BusSourcesPart {
            main_bus_sources: BusSource::new("MainBusSource"),
            address_bus_sources: BusSource::new("AddressBusSource"),
            alu_l_sources: BusSource::new("ALULSource"),
            alu_r_sources: BusSource::new("ALURSource"),
            flags_sources: BusSource::new("FlagsSource"),
        }
    }

    pub fn is_main_bus_source(dev_type: &str, name: &str) -> bool {
        match dev_type {
            "GPRegister" |
            "ALU" |
            "FlagsRegister" |
            "RAM" |
            "ROM" |
            "IOController"=> true,
            "TransferRegister" if name != "TX" => true,
            _ => false,
        }
    }

    pub fn is_alu_l_source(dev_type: &str) -> bool {
        match dev_type {
            "GPRegister" => true,
            _ => false,
        }
    }

    pub fn is_alu_r_source(dev_type: &str) -> bool {
        match dev_type {
            "GPRegister" |
            "TempRegister" => true,
            _ => false,
        }
    }

    pub fn is_address_bus_source(dev_type: &str, name: &str) -> bool {
        match dev_type {
            "ProgramCounter" |
            "AddressRegister" |
            "StackPointer" |
            "AddressCalculator" => true,
            "TransferRegister" if name == "TX" => true,
            _ => false,
        }
    }

    pub fn is_flags_source(dev_type: &str) -> bool {
        match dev_type {
            "ALU" => true,
            _ => false,
        }
    }

    pub fn emit(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        self.main_bus_sources.emit_struct(writer)?;
        self.alu_l_sources.emit_struct(writer)?;
        self.alu_r_sources.emit_struct(writer)?;
        self.address_bus_sources.emit_struct(writer)?;
        self.flags_sources.emit_struct(writer)
    }
}
