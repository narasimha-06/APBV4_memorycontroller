AMBA APB4 PROTOCOL VERIFICATION – WORKING PRINCIPLE

PROJECT OVERVIEW:

I worked on the verification of the AMBA APB4 (Advanced Peripheral Bus 4) protocol using a SystemVerilog-based verification environment. The project used a single-master and single-slave setup.

APB4 is a simple, low-power and non-pipelined protocol generally used for communication with low-bandwidth peripherals such as timers, GPIOs, UARTs and memory-mapped registers in a SoC.

The main objective of the project was to verify the correct operation of APB4 read and write transfers, protocol sequencing, wait-state handling, error signaling, protection attributes and byte-strobe functionality. The verification environment was developed entirely using SystemVerilog, with functional coverage and SystemVerilog Assertions used to improve verification completeness and check protocol compliance.

APB4 WORKING PRINCIPLE:

An APB transfer takes place through three phases:

1. IDLE PHASE:

The IDLE phase is the default state when there is no transfer in progress.

During this phase:
- PSEL is LOW.
- PENABLE is LOW.
- The slave is not selected.
- No APB transfer takes place.

When the master wants to communicate with the peripheral, it asserts the appropriate PSEL signal and moves the interface into the SETUP phase.

2. SETUP PHASE:

The SETUP phase is the first phase of an APB transfer and lasts exactly one clock cycle.

During SETUP:
- PSEL is asserted HIGH to select the slave.
- PENABLE remains LOW.
- PADDR contains the address of the location being accessed.
- PWRITE specifies whether the transfer is a read or write.
- PPROT contains the protection information.
- PWDATA contains the write data when performing a write.
- PSTRB indicates the valid byte lanes during a write.

The address and control signals are established during this phase.

At the next rising edge of the clock, the transfer moves from SETUP to ACCESS.

3. ACCESS PHASE:

The ACCESS phase is where the actual APB transfer takes place.

During ACCESS:
- PSEL remains HIGH.
- PENABLE is asserted HIGH.
- PADDR, PWRITE, PPROT, PWDATA and PSTRB remain stable.

The slave uses PREADY to indicate whether the transfer can be completed.

If PREADY is HIGH:
- The transfer completes.
- The interface can return to IDLE if there is no next transfer.
- If another transfer is required, it proceeds to the next SETUP phase.

If PREADY is LOW:
- The transfer is not yet complete.
- Wait states are inserted.
- The ACCESS phase is extended.
- The address and control information remains stable until PREADY becomes HIGH.

READ TRANSACTION:

For a read transaction:

1. The master selects the slave by asserting PSEL.
2. The master enters the SETUP phase and drives the required address on PADDR.
3. PWRITE is driven LOW to indicate a read.
4. The transfer moves to the ACCESS phase when PENABLE becomes HIGH.
5. The slave provides the requested data on PRDATA.
6. If the slave is not ready, PREADY remains LOW and the ACCESS phase is extended.
7. When PREADY becomes HIGH, the read transfer is completed.

WRITE TRANSACTION:

For a write transaction:

1. The master selects the required slave using PSEL.
2. During SETUP, the master drives the address on PADDR.
3. PWRITE is driven HIGH to indicate a write.
4. Write data is driven on PWDATA.
5. PSTRB indicates which byte lanes of PWDATA are valid.
6. During ACCESS, PENABLE becomes HIGH.
7. The slave accepts the transfer when PREADY becomes HIGH.
8. If PREADY remains LOW, wait states are introduced until the slave becomes ready.

APB4 SIGNALS USED:

PCLK:
The clock signal used to synchronize the APB transfer.

PRESETn:
The active-low reset signal used to initialize the APB interface.

PSEL:
Peripheral select signal used by the master to select the required slave.

PENABLE:
Indicates the ACCESS phase of an APB transfer. It is asserted in the cycle following SETUP.

PADDR [31:0]:
32-bit address bus used to specify the register or memory location being accessed.

PWRITE:
Indicates the type of transfer:
0 = Read
1 = Write

PWDATA [31:0]:
32-bit write-data bus driven by the master during a write transfer.

PRDATA [31:0]:
32-bit read-data bus driven by the slave during a read transfer.

PSTRB [3:0]:
Byte-strobe signal used for sparse writes. Each bit corresponds to one byte lane of PWDATA.

PPROT [2:0]:
Protection signal that specifies the type of transaction:
- PPROT[0]: Secure / Non-secure
- PPROT[1]: Normal / Privileged
- PPROT[2]: Data / Instruction

PREADY:
Signal driven by the slave to indicate that the transfer can be completed. If it remains LOW, wait states are inserted.

PSLVERR:
Error signal driven by the slave to indicate that the transaction resulted in an error.

SYSTEMVERILOG VERIFICATION ENVIRONMENT:

The complete verification environment for this project was developed using SystemVerilog.
The environment was organized into different classes and modules so that stimulus generation, signal driving, monitoring, checking, coverage and assertions could be handled separately.

The major components were:

1. TOP MODULE

The top module is the highest-level structural component of the SystemVerilog verification environment.

Its responsibilities include:
- Instantiating the DUT.
- Instantiating the SystemVerilog interface.
- Generating the clock.
- Connecting the interface to the DUT.
- Providing the reference clock to the DUT and interface.
- Creating the Test class object.
- Passing the interface handle to the Test class.
- Starting the verification process by invoking the Test class run method.

Therefore, the top module provides the overall connectivity and starts the simulation.

2. INTERFACE

The SystemVerilog interface provides a common connection between the DUT and the verification components.

It groups the APB signals such as:
- PCLK
- PRESETn
- PSEL
- PENABLE
- PADDR
- PWRITE
- PWDATA
- PRDATA
- PSTRB
- PPROT
- PREADY
- PSLVERR

The interface allows the verification components to access the DUT signals in a structured manner.

3. TEST CLASS

The Test class controls the verification flow.
The top module creates an object of the Test class and passes the interface handle to it.
The Test class then starts the verification process by invoking the required methods and initiating transaction generation.

4. TRANSACTION CLASS

The Transaction class represents an APB transaction at the data level.

It contains the information required to perform an APB transfer, such as:
- Address
- Read/write operation
- Write data
- Protection information
- Byte-strobe information

Instead of directly manipulating individual APB signals, the transaction object represents the complete operation that needs to be performed.

5. GENERATOR CLASS

The Generator is responsible for generating APB transactions.

It creates transaction objects with different combinations of:
- Read and write operations
- Addresses
- Data values
- Protection attributes
- Byte strobes

The generated transactions are passed to the Driver for execution.

6. DRIVER CLASS

The Driver converts the transaction-level information generated by the Generator into actual APB signal-level activity.

For every transaction, the Driver follows the APB protocol sequence:

IDLE
  ↓
SETUP
  ↓
ACCESS
  ↓
Wait if PREADY = 0
  ↓
Complete when PREADY = 1

For a write, the Driver drives PADDR, PWRITE, PWDATA, PSTRB and PPROT.
For a read, it drives the address and control information and waits for the slave response.
The Driver therefore acts as the connection between the abstract transaction and the actual DUT pins.

7. INPUT MONITOR

The Input Monitor observes the APB signals going into the DUT.

It monitors signals such as:
- PSEL
- PENABLE
- PADDR
- PWRITE
- PWDATA
- PSTRB
- PPROT

It captures the request being applied to the DUT and converts the observed activity into a transaction that can be used by other verification components.

8. OUTPUT MONITOR

The Output Monitor observes the response coming from the DUT.

It monitors signals such as:
- PRDATA
- PREADY
- PSLVERR

It captures the DUT response and sends the observed information for checking.

9. SCOREBOARD

The Scoreboard is responsible for checking the correctness of the DUT.
It receives the expected transaction information and the actual transaction information captured by the monitors.
The expected and actual results are compared.

For example:
- For a write, it checks whether the DUT accepts the write correctly.
- For a read, it checks whether the returned PRDATA is correct.
- It checks transfer completion using PREADY.
- It checks the expected error response using PSLVERR.

If the expected and actual results match, the transaction is considered correct.
If there is a mismatch, the Scoreboard reports a failure.

10. FUNCTIONAL COVERAGE

Functional coverage was used to determine whether the important APB4 scenarios had been exercised during simulation.
The coverage model was used to cover different aspects of APB transactions, including:
- Read transfers
- Write transfers
- Different addresses
- Different data values
- PSTRB combinations
- PPROT combinations
- PREADY behavior
- Wait-state scenarios
- Error conditions

The purpose of functional coverage was to ensure that the verification environment did not test only a small number of basic transactions but exercised the important protocol scenarios.

11. ASSERTIONS

SystemVerilog Assertions were used for assertion-based verification.
Assertions continuously monitor the DUT and check whether predefined APB protocol rules are satisfied.

Important protocol checks include:
- PSEL must be asserted before PENABLE.
- SETUP must occur before ACCESS.
- PENABLE must be LOW during SETUP.
- PSEL must remain HIGH during ACCESS.
- PADDR must remain stable during the transfer.
- PWRITE and other control signals must remain stable during wait states.
- PWDATA and PSTRB must remain stable when required.
- The transfer should complete when PREADY is asserted.

If a protocol rule is violated, the corresponding assertion reports the failure during simulation.

PROJECT WORKING IN SEQUENCE:

First, the Test class starts the verification environment from the top module.
The Generator creates an APB transaction. The transaction contains the required address, read/write information, data, protection information and byte-strobe information.
The Driver receives this transaction and drives the corresponding APB signals through the SystemVerilog interface.
The APB transfer starts in the IDLE state. When a transfer is required, PSEL is asserted and the interface enters the SETUP phase. During SETUP, the address and control information are driven.
In the next clock cycle, PENABLE is asserted and the transfer enters the ACCESS phase.
If PREADY is HIGH, the transfer completes. If PREADY is LOW, the Driver waits while the ACCESS phase continues. This verifies APB wait-state behavior.
For a read operation, the Output Monitor captures PRDATA from the DUT. For a write operation, the transaction and DUT response are monitored and checked.
The Input Monitor captures the request-side activity, while the Output Monitor captures the response-side activity
The Scoreboard compares the expected behavior with the actual DUT response and reports any mismatch.
Meanwhile, functional coverage records which APB scenarios have been exercised, and SystemVerilog Assertions continuously check whether the DUT follows the required APB protocol rules.
