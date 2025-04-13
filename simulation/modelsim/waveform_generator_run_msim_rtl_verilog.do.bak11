transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/wm8731_config.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/i2s_transmitter.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/i2c_master.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/clock_generator.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/waveform_generator.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/control.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/noise_injection.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/sawtooth_wave_gen.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/phase_accumulator.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/fir.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/sine_wave_gen.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/square_wave_gen.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/triangle_wave_gen.v}
vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/ecg_wave_gen.v}

vlog -vlog01compat -work work +incdir+D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main {D:/k242/Fgpa/fpga1.1/Fpga-main/Fpga-main/waveform_generator_tbn01.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  waveform_generator_tbn01

add wave *
view structure
view signals
run -all
