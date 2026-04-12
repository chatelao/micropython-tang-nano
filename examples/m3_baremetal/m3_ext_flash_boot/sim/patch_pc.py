from Antmicro.Renode.Core import RegisterValue
cpu = self.Machine["sysbus.cpu"]
cpu.PC = RegisterValue(cpu.PC.RawValue | 1)
