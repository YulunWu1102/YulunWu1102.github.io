**ALL Blog 6/8/2022**

Progress:

1. Module Summary
   1. Module: avalon\_microphone\_system
      1. Input: CLK, Reset, AVL\_READ, AVL\_WRITE, AVL\_CS, AVL\_ADDR, AVL\_WRITEDATA, AM\_WRITEREQUEST, AUD\_BCLK, AUD\_ADCLRCK, GPIO\_DIN1, GPIO\_DIN2, …, GPIO\_DIN8, [31:0] adc\_data
      1. Output: [31:0] AM\_ADDR, [2:0] AM\_BURSTOUNT, AM\_WRITE, [31:0] AM\_WRITEDATA, [3:0] AM\_BYTEENABLE, AVL\_READDATA, [15 + 16\*(CHANNELS-1): 0] mics, [(CHANNELS/2)-1:0] wsp, valid\_o, i2s\_out, [31:0] codec\_stream
      1. Description & Purpose: Main .sv file that most sub-system is built on.
   1. Module: downsample 
      1. Input: rst, LRCLK, i\_clk, [DATA\_WIDTH-1:0] sample\_in, i\_ce
      1. Output: [DATA\_WIDTH-1:0] sample\_out, ready
      1. Description & Purpose: 
         1. Downsampling the original data input “sample\_in” to “sample\_out” according to the “DOWN\_FACTOR”. It uses “LRCLK” clock for the down sampling “always\_ff” code.
         1. i\_ce: it’s the signal feed into the sub-module ‘slowfil’.
   1. Module: mic\_dma (direct memory access: access the memory independently with the CPU operation)
      1. Input: CLK, RESET, AM\_WAITREQUEST, mic\_data, start, read\_ready, [31:0] start\_address, [31:0] number\_samples, half\_way\_ack, end\_ack,
      1. Output: AM\_ADDR, [2:0] AM\_BURSTOUNT, AM\_WRITE, [31:0] AM\_WRITEDATA, [3:0] AM\_BYTEENABLE, half\_way\_latch, end\_latch, FINISHED
      1. Description & Purpose: 
         1. Directly assign ‘mic\_data’ to ‘AM\_WRITEDATA’, but allocate the data to specific address (AM\_ADDR) based on inner logic.
         1. The ‘mic\_sel’ is output, and it affects the ‘ready\_data\_choice’ in latter code
   1. Module: remove\_dc
      1. Input: clk, rst, [15:0] gain, [15:0] mic\_in, calibrate
      1. Output: [15:0] mic\_out
      1. Description & Purpose: output the data ‘mic\_out’ with removement of DC. In first 65536 clock cycle, offset is zero, and ‘mic\_output’ is the multiplication of gain and ‘mic\_in’. After that, in each 65536 cycle, the output will be reduced by the previous 65536-cycle accumulation divided by 65536. (\*seems like ‘gain’ is never being assigned by a value). Output is stored in ‘mics\_normal\_net’ variable in AMS.
   1. Module: remove\_dc
   1. Module: altera\_up\_clock\_edge
   1. Module: i2s\_tx
   1. Module: i2s\_master
1. Upgrade Quartus to 19.1, fix downgrade problem, but still missing stuff in platform designer, but NIOS2 can’t work. Maybe re-install tomorrow.
1. SV note:
   1. Operator {{}}: replication Operator
      1. E.g.: a = 1’b1, y = {4{a}}, y = 4’b1111
   1. Arrays summary:
      1. Packed array: logic [x:0][y:0] data
         1. m\_data[0] is the first (y-1) bit logic
      1. Unpacked array:
         1. Stack [2][4]: 2 rows, 4 cols
         1. Packed + unpacked array: logic [7:0] stack [3]
            1. ` `xxxxxxxxxxx76543210 \n xxxxxxxxxxx76543210 \n xxxxxxxxxxx76543210 \n

Issue:

1. NIOS-2 can’t open
1. Haven’t associated the i2s module with platform designer or nios2 part

Plan:

1. Finish remaining documentation of modules (slowfil, i2s)
1. Figure out NIOS-2 problem
















