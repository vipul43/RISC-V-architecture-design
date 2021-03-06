`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2020 04:36:25
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module reg_file(input [2:0]sup, input control, input MemToReg, input clk, input [4:0]address, input write, input [63:0]in, input [63:0]in_m,
            output [63:0]out
);
    
    reg [63:0]registers[0:31];
    reg [63:0]hold;
    reg [63:0] wrt;
    reg [63:0] check;
    integer i;
    integer r_file;
    integer file_output;
    initial begin
        r_file = $fopen("register.txt", "r");
        for(i=0;i<32;i=i+1)begin
            $fscanf(r_file, "%b\n", registers[i]);
        end
    end
    always @ (posedge clk)begin
        if(write == 1'b0)begin                  //all cases
            hold <= registers[address]; 
        end
        else if(write==1'b1)begin
            if(control==1'b1 && MemToReg==1'b0)begin             //rtype, itype          
                registers[address] <= in;
                check<=in;
            end
            else if(control==1'b1 && MemToReg==1'b1) begin      //load
                registers[address] <= in_m;
                file_output = $fopen("register.txt", "w");
                for(i=0;i<32;i=i+1)begin
                    $fwrite(file_output, "%b\n", registers[i]);
                end
                wrt<=in_m;
                $fclose(file_output);
            end
        end
    end
    assign out = hold;
always @(posedge clk)begin
    if(MemToReg==1'b0 && control==1'b1)begin
        file_output = $fopen("register.txt", "w");
        for(i=0;i<32;i=i+1)begin
            $fwrite(file_output, "%b\n", registers[i]);
        end
        wrt<=check;
        $fclose(file_output);
    end
end
endmodule
