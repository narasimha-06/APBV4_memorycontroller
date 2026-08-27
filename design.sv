
module APB_INTERFACE_V6 #(parameter ADDR_SIZE=1024 )(
      input reset_n, pclock,
      input pselx,
      input penable,
      input [31:0]paddr,
      input [31:0]pw_data,
      input pwrite,
      //input pwakeup,
      input [2:0]pprot,
      input [3:0]pstrobe,
      output [31:0]pr_data,
      output pready,
      output pslverror
					 );

     wire sA_sel,sB_sel;
     wire pwakeupA,pwakeupB;
     wire [2:0]pprotA,pprotB;
     wire [3:0]pstrobeA,pstrobeB;
     wire penableA,pwriteA,preadyA,pslverrorA;
     wire [31:0]paddrA,pw_dataA,pr_dataA;
     wire [31:0]paddrB,pw_dataB,pr_dataB;
     wire pwriteB, penableB,preadyB,pslverrorB;
     ///======================input mapping ================================================================================//	
     assign {sA_sel,sB_sel} = (reset_n==0) ? {1'b0,1'b0} : (paddr< 'h190 ? {pselx,1'b0}:{1'b0,pselx});
   //  assign {pwakeupA,pwakeupB} = (reset_n==0) ? {1'b0,1'b0} : (paddr< 'h190 ? {pwakeup,1'b0}:{1'b0,pwakeup});
     assign pprotA = (sA_sel) ? pprot: 3'd0;
     assign pprotB = (sB_sel) ? pprot: 3'd0;
     assign pstrobeA = (sA_sel) ? pstrobe: 3'd0;
     assign pstrobeB = (sB_sel) ? pstrobe: 3'd0;
     assign paddrA = (sA_sel) ? paddr: 32'b0;
     assign paddrB = (sB_sel) ? paddr: 32'b0;
     assign pw_dataA = (sA_sel) ? pw_data: 32'b0;
     assign pw_dataB = (sB_sel) ? pw_data: 32'b0;
     assign pwriteA = (sA_sel) ? pwrite: 1'b0;
     assign pwriteB = (sB_sel) ? pwrite: 1'b0;
     assign penableA = (sA_sel) ? penable: 1'b0;
     assign penableB = (sB_sel) ? penable: 1'b0;
     
     ///======================output mapping ================================================================================//	
     assign pr_data = ({sA_sel,sB_sel}==2'b10) ? pr_dataA : ( ({sA_sel,sB_sel}==2'b01) ? pr_dataB : 0 );
     assign pready = ({sA_sel,sB_sel}==2'b10) ? preadyA : (({sA_sel,sB_sel}==2'b01) ? preadyB : 0 );
     assign pslverror = ({sA_sel,sB_sel}==2'b10) ? pslverrorA : ( ({sA_sel,sB_sel}==2'b01) ? pslverrorB : 0 );
     apb_slaveA duta(reset_n,pclock,sA_sel,penableA,paddrA,pw_dataA,pwriteA,pprotA,pstrobeA, pr_dataA,preadyA,pslverrorA);

     apb_slaveB dutb(reset_n,pclock,sB_sel,penableB,paddrB,pw_dataB,pwriteB,pprotB,pstrobeB, pr_dataB,preadyB,pslverrorB);

endmodule

module apb_slaveA #(parameter LOC_SIZE=512 )(
					 input reset, pclock,
					 input pselx,
					 input penable,
					 input [31:0]paddr,
					 input [31:0]pw_data,
					 input pwrite,
					 input [2:0]pprot,
					 input [3:0]pstrobe,
					 output reg [31:0]pr_data,
					 output reg pready,
					 output reg pslverror
					 );

	//=========================== local members ==============================================================================================//
	reg [31:0]DATA_MEMORY[LOC_SIZE-1:0];				// 1024 address location each with 32 bit capcity
	reg [31:0]DATA_MEMORYS[LOC_SIZE-1:0];				// 1024 address location each with 32 bit capcity
	reg [31:0]CONTROL_MEMORY [LOC_SIZE-1:0];	
	localparam	IDLE = 2'd0,SET_UP=2'd1, ACCESS=2'd2;
     	localparam ENCODE_KEYA = 8'b10101010;
     	localparam ENCODE_KEYB = 8'b01010101;

	reg [1:0]state;
	integer index;
	reg EnA,EnB,EnC;
  	reg [31:0]temp_data;
	reg [31:0]temp_addr;
	reg temp_RW;


	//================================ state handling ========================================================================================//
	
 always@(posedge pclock) begin
  if(!reset) begin
    state <= IDLE;
    temp_data<=0;
    temp_addr<=0;
    temp_RW <=0;
  end else 
  begin
  if(pselx) begin
    //$display("============AAAAAAA===================SLAVE-A===============================");
    if(!penable) begin
     state<=SET_UP;
    end else begin
     state <= ACCESS;
    end
    end else begin
     state <=IDLE;
    end
  end
 end

//================================For READY sigbnal ===
//------address based memory access ------------
always @(posedge pclock) begin

	if(!reset) begin 
	  EnA <=1'b0; EnB<=1'b0; EnC <=1'b0;
	end else begin
	  if(paddr>=0 && paddr<=99) begin EnA <=1'b1; EnB<=1'b0; EnC <=1'b0; end 
	  if(paddr>99 && paddr<=199) begin EnA <=1'b0; EnB<=1'b1; EnC <=1'b0; end
	  if(paddr>199 && paddr<=399) begin EnA <=1'b0; EnB<=1'b0; EnC <=1'b1; end
	end
end
always@(posedge pclock)begin
	if(state == IDLE || state == SET_UP) begin
		pready		<='b0;
	end else begin
		pready		<='b1;
	end
end
	//================================ state functionality ====================================================================================//
 always@(posedge pclock) begin
// $display("$$$$$$$$$$$$$$$$$$$$$------YEAH----------------DATA--------------------$$$$$$$$$$$$$$\n MEM=%p \n MEMDTA=%0d", DATA_MEMORY,DATA_MEMORY[paddr]);
 //$display("$$$$$$$$$$$$$$$$$$$$$------YEAH----------------CONTROL--------------------$$$$$$$$$$$$$$\n CONTRMEM=%p \n ", CONTROL_MEMORY);
 case(state)
 IDLE:
	  begin
	  pr_data 		<='d0;
	  pslverror		<='b0;
	 // pready		<='b0;
	  for(index=0;index<LOC_SIZE;index=index+1'b1) 
	  	begin
			DATA_MEMORY[index]<=0; // reset memory
			DATA_MEMORYS[index]<=0; // reset memory
			CONTROL_MEMORY[index]<=0;
		end

	  end
 
 SET_UP: 
	  begin
	  temp_data 			<= pw_data;
	  temp_addr			<= paddr;
	  temp_RW			<= pwrite;
	 // pready			<= 1'b1;
	  pslverror 			<= 1'b0;
	  end
 
 ACCESS: begin //{ ---------------------------ACCESS START ------------------------------------------------

	    //  $display("$$$$$$$$$$$$$$$$---------$$$$$$$$$-------$$$$$$$$$$$$$");
	    //  $display("$$$$$$$$$------ACCESS PHASE  MEMEORY---------$$$$$$$$$$$$$");
	    //  $display("$$$$$$$$$$$$$$---------$$$$$$$$$--------$$$$$$$$$$$$$");

      if(pw_data!=temp_data || paddr!=temp_addr || pwrite!=temp_RW || paddr%4!=0) 	pslverror <=1;
      
      if(pwrite) begin //{ ---WRITE ----------
	if(pprot==3'b001 && EnA==1'b1) begin //{			//A secured data acess with previlages 
	   $display("===============================SECURE DATA MEMEORY--\n memdata=%p ", DATA_MEMORYS);

	 if(&pstrobe) begin
	      DATA_MEMORYS[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][15:8] <= pw_data[15:8]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][23:16] <= pw_data[23:16]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][31:16] <= pw_data[31:16]^ENCODE_KEYA;
	 end 
	 else 
	 begin // { strobe else
	  case (pstrobe)
	      // Single byte valid cases
	      4'b0001: begin 
	      DATA_MEMORYS[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYA;
	      end
	      4'b0010: begin
	      DATA_MEMORYS[paddr][15:8] <= pw_data[15:8]^ENCODE_KEYA;
	      end
	      4'b0100: begin 
	      DATA_MEMORYS[paddr][23:16] <= pw_data[23:16]^ENCODE_KEYA;
	      end
	      4'b1000: begin
	      DATA_MEMORYS[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYA;
	      end
	      // Two bytes valid (contiguous)
	      4'b0011: begin 
	      DATA_MEMORYS[paddr][15:0] <= pw_data[15:0]^ENCODE_KEYA;
	      end
	      4'b0110: begin
	      DATA_MEMORYS[paddr][23:8] <= pw_data[23:8]^ENCODE_KEYA;
	      end
	      4'b1100: begin 
	      DATA_MEMORYS[paddr][31:16] <= pw_data[31:16]^ENCODE_KEYA;
	      end
	      
	      // Two bytes valid (non-contiguous)
	      4'b0101: begin
	      DATA_MEMORYS[paddr][23:16] <= pw_data[23:16]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYA;
	      end
	      4'b1001: begin
	      DATA_MEMORYS[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYA;
	      end
	      4'b1010: begin
	      DATA_MEMORYS[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][15:8] <= pw_data[15:8]^ENCODE_KEYA;
	      end
	      
	      // Three bytes valid
	      4'b0111: begin 
	      DATA_MEMORYS[paddr][23:0] <= pw_data[23:0]^ENCODE_KEYA;
	      end 
	      4'b1011: begin
	      DATA_MEMORYS[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][15:0] <= pw_data[15:0];
	      end
	      4'b1101: begin
	      DATA_MEMORYS[paddr][31:16] <= pw_data[31:16]^ENCODE_KEYA;
	      DATA_MEMORYS[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYA;
	      end
	      4'b1110: begin
	      DATA_MEMORYS[paddr][31:8] <= pw_data[31:8]^ENCODE_KEYA;
	      end 
	      // Default case (including 4'b0000)
	      default: begin 
	      DATA_MEMORYS[paddr] <= 32'h0;
	      end 
	   endcase
	      // $display("SECURED DATA MEMORY AFTER UPDATE : %p",DATA_MEMORYS);
	  end // } strobe else end
	 end // } prot end
       else 
       if(pprot==3'b101 && EnB==1'b1) begin	// An instruction access ..secured ...previlaged
	       $display("===============================CONTROL_MEMORY  UPDATE : \n %p",CONTROL_MEMORY);
	  case (pstrobe)
	      // Single byte valid cases
	      4'b0001: begin 
	      CONTROL_MEMORY[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYB;
	      end
	      4'b0010: begin
	      CONTROL_MEMORY[paddr][15:8] <= pw_data[15:8]^ENCODE_KEYB;
	      end
	      4'b0100: begin 
	      CONTROL_MEMORY[paddr][23:16] <= pw_data[23:16]^ENCODE_KEYB;
	      end
	      4'b1000: begin
	      CONTROL_MEMORY[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYB;
	      end
	      // Two bytes valid (contiguous)
	      4'b0011: begin 
	      CONTROL_MEMORY[paddr][15:0] <= pw_data[15:0]^ENCODE_KEYB;
	      end
	      4'b0110: begin
	      CONTROL_MEMORY[paddr][23:8] <= pw_data[23:8]^ENCODE_KEYB;
	      end
	      4'b1100: begin 
	      CONTROL_MEMORY[paddr][31:16] <= pw_data[31:16]^ENCODE_KEYB;
	      end
	      
	      // Two bytes valid (non-contiguous)
	      4'b0101: begin
	      CONTROL_MEMORY[paddr][23:16] <= pw_data[23:16]^ENCODE_KEYB;
	      CONTROL_MEMORY[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYB;
	      end
	      4'b1001: begin
	      CONTROL_MEMORY[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYB;
	      CONTROL_MEMORY[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYB;
	      end
	      4'b1010: begin
	      CONTROL_MEMORY[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYB;
	      CONTROL_MEMORY[paddr][15:8] <= pw_data[15:8]^ENCODE_KEYB;
	      end
	      
	      // Three bytes valid
	      4'b0111: begin 
	      CONTROL_MEMORY[paddr][23:0] <= pw_data[23:0]^ENCODE_KEYB;
	      end 
	      4'b1011: begin
	      CONTROL_MEMORY[paddr][31:24] <= pw_data[31:24]^ENCODE_KEYB;
	      CONTROL_MEMORY[paddr][15:0] <= pw_data[15:0];
	      end
	      4'b1101: begin
	      CONTROL_MEMORY[paddr][31:16] <= pw_data[31:16]^ENCODE_KEYB;
	      CONTROL_MEMORY[paddr][7:0] <= pw_data[7:0]^ENCODE_KEYB;
	      end
	      4'b1110: begin
	      CONTROL_MEMORY[paddr][31:8] <= pw_data[31:8]^ENCODE_KEYB;
	      end 
	      // Default case (including 4'b0000)
	      default: begin 
	      CONTROL_MEMORY[paddr] <= 32'h0;
	      end 
	  endcase												
	 end //prot end
	 else if(pprot==010 && EnC==1'b1) // ---data non secured with no previlages
	 begin //{
	       $display("===============================NON SECURE_MEMORY  UPDATE : \n %p",CONTROL_MEMORY);
	       case (pstrobe)
	       
	       4'b0001: begin 
	       DATA_MEMORY[paddr][7:0] <= pw_data[7:0];
	       end
	       4'b0010: begin
	       DATA_MEMORY[paddr][15:8] <= pw_data[15:8];
	       end
	       4'b0100: begin 
	       DATA_MEMORY[paddr][23:16] <= pw_data[23:16];
	       end
	       4'b1000: begin
	       DATA_MEMORY[paddr][31:24] <= pw_data[31:24];
	       end

	       
	       4'b0011: begin 
	       DATA_MEMORY[paddr][15:0] <= pw_data[15:0];
	       end
	       4'b0110: begin
	       DATA_MEMORY[paddr][23:8] <= pw_data[23:8];
	       end
	       4'b1100: begin 
	       DATA_MEMORY[paddr][31:16] <= pw_data[31:16];
	       end
	       4'b0101: begin
	       DATA_MEMORY[paddr][23:16] <= pw_data[23:16];
	       DATA_MEMORY[paddr][7:0] <= pw_data[7:0];
	       end
	       4'b1001: begin
	       DATA_MEMORY[paddr][31:24] <= pw_data[31:24];
	       DATA_MEMORY[paddr][7:0] <= pw_data[7:0];
	       end
	       4'b1010: begin
	       DATA_MEMORY[paddr][31:24] <= pw_data[31:24];
	       DATA_MEMORY[paddr][15:8] <= pw_data[15:8];
	       end

	       4'b0111: begin 
	       DATA_MEMORY[paddr][23:0] <= pw_data[23:0];
	       $display("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ------------ DATA_MEMORY=%p",DATA_MEMORY);
	       end 
	       4'b1011: begin
	       DATA_MEMORY[paddr][31:24] <= pw_data[31:24];
	       DATA_MEMORY[paddr][15:0] <= pw_data[15:0];
	       end
	       4'b1101: begin
	       DATA_MEMORY[paddr][31:16] <= pw_data[31:16];
	       DATA_MEMORY[paddr][7:0] <= pw_data[7:0];
	       end
	       4'b1110: begin
	       DATA_MEMORY[paddr][31:8] <= pw_data[31:8];
	       end 
	       
	       default: begin 
	       DATA_MEMORY[paddr] <= 32'h0;
	       end 
	       endcase
	 end //}
	 else begin
	      pslverror 	<= 1'b1;	
	 end
     end // } -----WRITE-------

     else begin	//{ [ ----------------READ---------------------
       if(pselx && !pwrite) begin
	case(pprot)
		3'b010: begin
	  		pr_data		<= DATA_MEMORY[paddr];
	  		pslverror 	<= 1'b0;
		//	$display($time,"\t $$$$$$---- DATA SECURED AND PROTECTED....DATA_MEMORY[paddr]=%0d  paddr=%0d",DATA_MEMORY[paddr],paddr);
		end

		3'b001: begin
			pr_data		<= DATA_MEMORYS[paddr];
	  		pslverror 	<= 1'b1;	
		end

		3'b101: begin
	  		pslverror 	<= 1'b1;
	 		 pr_data	<= 32'hAA_BB_CC_DD;
		end

		default: begin
	  		pslverror 	<= 1'b1;
	  		pr_data		<= 32'hFF_FF_FF_FF;
		end

	endcase
       end
     end // } --------------------READ -------------------------
     
     //	$display("MEMORY====%p..ADD =%d...DATA=%d",DATA_MEMORY,paddr,pw_data);
    // pready							<= 0;
     
     end // }----------------------ACCESS END----------------------
 
 endcase
 end
 
 
 endmodule


module apb_slaveB #(parameter ADDR_SIZE=1024 )(
    input reset, pclock,
    input pselx,
    input penable,
    input [31:0]paddr,
    input [31:0]pw_data,
    input pwrite,
    input [2:0]pprot,
    input [3:0]pstrobe,
    output [31:0]pr_data,
    output pready,
    output pslverror
    );

    localparam	IDLE = 2'd0,SET_UP=2'd1, ACCESS=2'd2;
    //parameter DELAY= 32'd2000;	// wait timer to provide slave ready signal =1
    
    reg [31:0]DELAY;
    reg [1:0]state,next;
    reg ready, nextready;
    reg [31:0]readdata,next_readdata;
    reg error,nexterror;
    reg [31:0]tick, nexttick;
    
    reg [31:0]MEMORY[ADDR_SIZE-1:0];				// 1024 address location each with 32 bit capcity
    integer index;
    reg WAIT_ENABLE;
    
    // ====================================local registers to store the data and address contents to check further
    reg [31:0]address,address_next;
    reg [31:0]data,data_next;
    reg goforwrite=0;						// signals raised when change in data and address are changed when moving from SET-UP to ACCESS phases
    


    always@(posedge pclock) begin
    if(!reset) begin
      state <= IDLE; 
      ready <=0;
      tick<=0;
      readdata<=0;
      error<=0; 
      DELAY<=1000;
      address<=0;
      data<=0;
      WAIT_ENABLE<=0;
    end else begin
      state <= next; 
      ready <= nextready; 
      tick <= nexttick;
      error<=nexterror;
      address<=address_next;
      data<=data_next;
      end 
    end

//========================================================================== next state logic
     always@(*) begin
      next 		= state;
      nextready	= ready;
      nexttick	= tick;
      nexterror	= error;
      address_next	= address;
      data_next	= data;
     
      case(state)
      IDLE: begin
	nextready				= 0;
	nexterror				= 0;
	for(index=0;index<ADDR_SIZE;index=index+1'b1) MEMORY[index]=0; // reset memory
	if(pselx) begin
	next = SET_UP;
	end else begin
	next = IDLE;
	end
      end
      
      SET_UP: begin
	nexterror	= 0;
	next		= ACCESS;
	
	// =========================== collect the address and data to check for the consitancy
	data_next	= pw_data;
	address_next	= paddr;
//	nextready	= 0;
	DELAY		=100;
	goforwrite	=0;
      end
      
      ACCESS: begin
	// ================================================reading or writing transfer
	if(pselx) 
		
	begin	
	//$display("===============================SLAVE-B===============================");
																
	// ===================================== still connected to slave
	 if(penable)	begin
	   //=========== write control signal update ===============
	   if(data==pw_data && address==paddr) begin 
	    nexterror		= 0;goforwrite=1;	
	   end	// raise salve error
	   else	begin 
	    nexterror		= 1; goforwrite=0; 
	   end
	   //=====================================================
	   if(pwrite && goforwrite)begin																	
	   // ==========================WRITE=======================
	     if(400<=paddr && paddr<410) begin
	     MEMORY[paddr] = 111111;	
	     end else begin
	     MEMORY[paddr] 	= pw_data;
	     end
	       $display("================================ APB3 MEMORY=%p",MEMORY);
	   end else begin											
	   // ==========================READ=======================
	     if(410<=paddr && paddr<=415)begin
	     readdata = 222222;		
	     end else begin
	     if(tick==DELAY-1)	readdata	= MEMORY[paddr];
	     end
	   end
	   //==========================cheks===========================
	   begin
	      if(tick==DELAY-1)begin
	      nexttick	= 0;
	      next		= SET_UP;
	      nextready	= 1'b1;
	      end else begin
	      nexttick	= tick+1'b1;
	      next		= ACCESS;
	      nextready	= 1'b0;
	      end
	   end
	  end // enable end
	   else begin			
	   nexterror	= 0;
	   nextready	= 1'b0;
	   readdata	= readdata;
	   next		= SET_UP;
	   end
	   end// disconnected from slave as (slection ==0) so slave should go to idel phase
	 else begin
	   nexterror	= 0;
	   nextready	= 1'b0;

       
       
      readdata	= readdata;
	   next 		= IDLE;
	 end
	end// state end
      endcase
end

//======= output logic

assign pready = ready;
assign pr_data = readdata;
assign pslverror = error;

  always @(posedge pclock) begin
    $display($time,"\t from actual DUT : PREADY : %0d \t ",pready);
  end

endmodule