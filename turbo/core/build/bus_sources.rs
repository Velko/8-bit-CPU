pub struct BusSourcesPart {
    pub main_bus_sources: Vec<String>,
    pub address_bus_sources: Vec<String>,
    pub alu_l_sources: Vec<String>,
    pub alu_r_sources: Vec<String>,
    pub flags_sources: Vec<String>,
}

impl BusSourcesPart {
    pub fn new() -> Self {
        BusSourcesPart {
            main_bus_sources: Vec::new(),
            address_bus_sources: Vec::new(),
            alu_l_sources: Vec::new(),
            alu_r_sources: Vec::new(),
            flags_sources: Vec::new(),
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
        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum MainBusSource {{")?;
        for source in self.main_bus_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum ALULSource {{")?;
        for source in self.alu_l_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum ALURSource {{")?;
        for source in self.alu_r_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum AddressBusSource {{")?;
        for source in self.address_bus_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum FlagsSource {{")?;
        for source in self.flags_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        Ok(())
    }
}
