module asynchronous_fifo(write_clk,read_clk,reset,write_en,read_en,data_in,mem_full,mem_empty,out);

//port declarations
input write_clk, read_clk, reset, write_en, read_en ;
input [7:0] data_in;
output mem_full, mem_empty;
output reg [7:0] out;

reg [7:0] mem [0:7];       //8 * 8 memory
reg [2:0] write_ptr;
reg [2:0] read_ptr;
reg [3:0] count;

//condition for mem_full and empty
assign mem_full  = (count == 8);
assign mem_empty = (count == 4'b0);

always @ (posedge write_clk or negedge reset)
   begin
      if(!reset)
         begin
            write_ptr <= 3'b0;         //reset pointer
         end
      else
         begin
            if(write_en == 1 && !mem_full)
               begin
                  mem[write_ptr] <= data_in;      //data is written 
                  write_ptr<= write_ptr + 1'b1;  //pointer increment
                  out <= 8'bz;
               end
         end
    end


always @ (posedge read_clk or negedge reset)
   begin
      if(!reset)
         begin
            read_ptr <= 3'b0;                         //reset pointer
         end
      else
         begin
            if(read_en == 1 && !mem_empty)
               begin
                  out<= mem[read_ptr];            //data is read 
                  read_ptr <= read_ptr + 1'b1;    //pointer increment
               end
         end
    end

/*increment count for write enable 1 and decrement count for read enable 1*/
always @ (posedge write_clk or posedge read_clk or negedge reset)
   begin
      if(!reset)
         count <= 4'b0;                                //reset counter
      else
         begin
            case({write_en,read_en})
               2'b10:  count <= count + 1'b1;          //counter increment
               2'b01:  count <= count - 1'b1;         //counter increment
               default:count <= count;
            endcase 
         end
   end
endmodule                                           
