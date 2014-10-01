################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/game_logic.c \
../src/helloworld.c \
../src/platform.c \
../src/vga.c 

LD_SRCS += \
../src/lscript.ld 

OBJS += \
./src/game_logic.o \
./src/helloworld.o \
./src/platform.o \
./src/vga.o 

C_DEPS += \
./src/game_logic.d \
./src/helloworld.d \
./src/platform.d \
./src/vga.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -Os -ffast-math -c -fmessage-length=0 -I../../standalone_bsp_0/microblaze_0/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.40.a -mno-xl-soft-mul -mhard-float -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


