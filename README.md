# UVM Verification of Configurable Data Aligner

A scalable SystemVerilog/UVM verification environment for a configurable data aligner IP featuring reusable APB and custom MD protocol VIPs, predictor , scoreboarding, RAL integration, constrained-random verification, functional coverage, and assertion-based protocol checking.
<br>
<br>

 <div align="center">

<img src="images/Aligner_DUT_Env_Architecture.png"
     width="1000"
     style="border-radius:12px;">

</div>
<br>


## Project Overview

The Aligner DUT accepts an unaligned stream of memory data transactions and converts them into aligned output transactions based on programmable configuration registers. The design supports configurable alignment size and offset settings through an APB register interface.

The verification environment was developed using **SystemVerilog and UVM** with emphasis on:

- reusable VIP development
- constrained-random verification
- protocol compliance checking
- scalable UVM architecture
- end-to-end functional correctness

The DUT supports:

- APB-based register programming
- Custom MD (Memory Data) streaming protocol
- RX/TX FIFO buffering
- Interrupt generation
- Error detection for illegal transactions
- Flow-control and backpressure handling


## DUT Architecture
<br>

 <div align="center">

<img src="images/DUT_Block_Diagram.png"
     width="1000"
     style="border-radius:12px;">

</div>
<br>

The DUT consists of:

- RX Controller
- RX FIFO
- Alignment Controller
- TX FIFO
- TX Controller
- APB Register Interface
- Interrupt Logic

The aligner receives unaligned MD transactions from the RX interface, performs alignment based on programmable configuration registers, and transmits aligned data through the TX interface.