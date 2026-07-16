#################################################################################################
# Makefile chuẩn cho Icarus Verilog & GTKWave 
# Tối ưu cho môi trường có cài sẵn Quartus/IntelFPGA
#################################################################################################

# --- Biến cấu hình ---
TESTNAME    ?= radix4_Booth_mul
TB_NAME     ?= test_bench
SIM_BIN      = sim.out
WAVE_FILE    = wave.vcd
LOG_FILE     = $(TESTNAME).log
COMPILE_LOG  = compile.log

# Lệnh để "né" thư viện cũ của Quartus
CLEAN_ENV    = env -u LD_LIBRARY_PATH

# --- Mục tiêu chính ---
all: build run

# --- Bước 1: Biên dịch (Build) ---
build:
	@rm -f $(SIM_BIN)
	@echo "-----------------------------------------------"
	@echo "  Compiling: $(TESTNAME)"
	@echo "-----------------------------------------------"
	@# Chạy iverilog với môi trường sạch
	-$(CLEAN_ENV) iverilog -o $(SIM_BIN) -f compile.f 2>&1 | tee $(COMPILE_LOG)
	@echo ""
	@echo "-----------------------------------------------"
	@echo " Compile Finished "
	@echo "-----------------------------------------------"
	@printf "  Errors:   "
	@grep -ic "error" $(COMPILE_LOG) || printf "0"
	@echo ""
	@printf "  Warnings: "
	@grep -ic "warning" $(COMPILE_LOG) || printf "0"
	@echo ""
	@echo "-----------------------------------------------"
	@if [ -f $(SIM_BIN) ]; then \
		echo "  STATUS: BUILD SUCCESSFUL"; \
	else \
		echo "  STATUS: BUILD FAILED (Check compile.log)"; \
	fi
	@echo "-----------------------------------------------"

# --- Bước 2: Chạy mô phỏng (Run) ---
run:
	@if [ ! -f $(SIM_BIN) ]; then \
		echo "Lỗi: Chưa có file $(SIM_BIN). Hãy chạy 'make build' trước."; \
		exit 1; \
	fi
	$(CLEAN_ENV) vvp $(SIM_BIN) -l $(LOG_FILE)

# --- Bước 3: Xem sóng (Wave) ---
wave:
	@if [ ! -f $(WAVE_FILE) ]; then \
		echo "Lỗi: Không tìm thấy file sóng $(WAVE_FILE)."; \
	else \
		$(CLEAN_ENV) gtkwave $(WAVE_FILE) & \
	fi

# --- Các tiện ích khác ---
clean:
	rm -f $(SIM_BIN) $(WAVE_FILE) $(COMPILE_LOG) $(LOG_FILE)
	rm -f run_test.v	

help:
	@echo "*****************************************************"
	@echo "** make build     : Biên dịch Verilog bằng iverilog  "
	@echo "** make run       : Chạy mô phỏng bằng vvp           "
	@echo "** make all       : Thực hiện cả Build và Run        "
	@echo "** make wave      : Mở sóng bằng GTKWave             "
	@echo "** make clean     : Xóa các file rác phát sinh       "
	@echo "*****************************************************"
