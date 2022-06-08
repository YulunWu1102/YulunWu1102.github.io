**ALL Blog 6/7/2022**

Progress:

1. Module Summary
   1. Module: avalon\_microphone\_system
      1. Input: CLK, Reset, AVL\_READ, AVL\_WRITE, AVL\_CS, AVL\_ADDR, AVL\_WRITEDATA, AM\_WRITEREQUEST, AUD\_BCLK, AUD\_ADCLRCK, GPIO\_DIN1, GPIO\_DIN2, …, GPIO\_DIN8, [31:0] adc\_data
      1. Output: [31:0] AM\_ADDR, [2:0] AM\_BURSTOUNT, AM\_WRITE, [31:0] AM\_WRITEDATA, [3:0] AM\_BYTEENABLE, AVL\_READDATA, [15 + 16\*(CHANNELS-1): 0] mics, [(CHANNELS/2)-1:0] wsp, valid\_o, i2s\_out, [31:0] codec\_stream
      1. Description & Purpose: Main .sv file that most sub-system is built on.
   1. Module: downsample 
      1. Input: rst, LRCLK, i\_clk, [DATA\_WIDTH-1:0] sample\_in, i\_ce
      1. Output: [DATA\_WIDTH-1:0] sample\_out, ready
      1. Description & Purpose: Downsampling the original data input “sample\_in” to “sample\_out” according to the “DOWN\_FACTOR”. It uses “LRCLK” clock for the down sampling “always\_ff” code.
   1. Module: altera\_up\_clock\_edge
   1. Module: remove\_dc
   1. Module:
   1. Module: mic\_dma
   1. Module: i2s\_tx
   1. Module: i2s\_master
1. Upgrade Quartus to 19.1, fix downgrade problem, but still missing stuff in platform designer

Issue:

1. SV: Not finish module understanding
1. Platform designer: “fir\_system\_0” missing connection start, fix it ASAP

Plan:

1. Finish module description tomorrow
1. Go to CSL and take a look at the block diagram
