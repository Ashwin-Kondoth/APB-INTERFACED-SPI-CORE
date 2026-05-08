`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:30:22 02/09/2026 
// Design Name: 
// Module Name:    Shift_register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Shift_register(
    input PCLK,
    input PRESET_n,
    input ss_i,
    input send_data_i,
    input lsbfe_i,
    input cpha_i,
    input cpol_i,
    input miso_receive_sclk_i,
    input miso_receive_sclk0_i,
    input mosi_send_sclk_i,
    input mosi_send_sclk0_i,
    input [7:0] data_mosi_i,
    input miso_i,
    input receive_data_i,
    output reg mosi_o,
    output wire [7:0] data_miso_o
    );
	 
reg [2:0]count,count1,count2,count3;
reg [7:0]shift_register, temp_register;

assign data_miso_o = (receive_data_i) ? temp_register : 8'h00;

always @(posedge PCLK or negedge PRESET_n)
begin
	if(!PRESET_n)
		shift_register <= 8'b0;
	else if(send_data_i)
		shift_register <= data_mosi_i;
	else
		shift_register <= shift_register;
end

always @(posedge PCLK or negedge PRESET_n)
begin
	if(!PRESET_n)
	begin
		count2 <= 3'b000;
		count3 <= 3'b111;
		temp_register <= 8'd0;
	end
	else if(!ss_i)
	begin
		if(cpha_i ^ cpol_i)
		begin
			if(lsbfe_i)
			begin
				if(count <= 3'd7)
				begin
					if(miso_receive_sclk0_i)
					begin
						count2 <= count2 + 1'b1;
						temp_register[count2] <= miso_i;
					end
					else
					begin
						count2 <= count2;
						temp_register <= temp_register;
					end
				end
				else
				begin
					count2 <= 3'd0;
					temp_register <= 8'd0;
				end
			end
			else
			begin
				if(count >= 3'd0)
				begin
					if(miso_receive_sclk0_i)
					begin
						temp_register[count3] <= miso_i;
						count3 <= count3 - 1'b1;
					end
					else
					begin
						temp_register <= temp_register;
						count3 <= count3;
					end
				end
				else
				begin
					count3 <= 3'd7;
					temp_register <= 8'd0;
				end
			end
		end
		else
		begin
			if(lsbfe_i)
			begin
				if(count2 <= 3'd7)
				begin
					if(miso_receive_sclk_i)
					begin
						count2 <= count2 + 1'b1;
						temp_register[count2] <= miso_i;
					end
					else
					begin
						count2 <= count2;
						temp_register <= temp_register;
					end
				end
				else
				begin
					count2 <= 3'd0;
					temp_register <= 8'd0;
				end
			end
			else
			begin
				if(count3 >= 3'd0)
				begin
					if(miso_receive_sclk_i)
					begin
						count3 <= count3 - 1'b1;
						temp_register[count3] <= miso_i;
					end
				else
				begin
					count3 <= count3;
					temp_register <= temp_register;
				end
				end
				else
				begin
					count3 <= 3'd7;
					temp_register <= 8'd0;
				end
			end
		end
	end
	else
	begin
		count2 <= count2;
		count3 <= count3;
		temp_register <= temp_register;
	end
end

always @(posedge PCLK or negedge PRESET_n)
begin
	if(!PRESET_n)
	begin
		count <= 3'b000;
		count1 <= 3'b111;
		mosi_o <= 1'b0;
	end
	else if(!ss_i)
	begin
		if(cpha_i ^ cpol_i)
		begin
			if(lsbfe_i)
			begin
			mosi_o <= 1'b0;
				if(count <= 3'd7)
					if(mosi_send_sclk_i)
					begin
						count <= count + 1'b1;
						mosi_o <= shift_register[count];
					end
				else
				begin
					count <= 3'd0;
					mosi_o <= 1'b0;
				end
			end
			else
			begin
				if(count1 >= 3'd0)
				begin
					if(mosi_send_sclk_i)
					begin
						count1 <= count1 - 1'b1;
						mosi_o <= shift_register[count1];
					end
					else
					begin
						count1 <= count1;
						mosi_o <= mosi_o;
					end
				end
				else
				begin
					count1 <= 3'd7;
					mosi_o <= 1'b0;
				end
			end
		end
		else
		begin
			if(lsbfe_i)
			begin
			mosi_o <= 1'b0;
				if(count <= 3'd7)
				begin
					if(mosi_send_sclk0_i)
					begin
						count <= count + 1'b1;
						mosi_o <= shift_register[count];
					end
					else
					begin
						count <= count;
						mosi_o <= mosi_o;
					end
				end
				else
				begin
					count <= 3'd0;
					mosi_o <= 1'b0;
				end
			end
			else
			begin
				if(count1 >= 3'd0)
				begin
					if(mosi_send_sclk0_i)
					begin
						count1 <= count1 - 1'b1;
						mosi_o <= shift_register[count1];
					end
					else
					begin
						count1 <= count1;
						mosi_o <= mosi_o;
					end
				end
				else
				begin
					count1 <= 3'd7;
					mosi_o <= 1'b0;
				end
			end
		end
	end
	else
	begin
		count <= count;
		count1 <= count1;
		mosi_o <= mosi_o;
	end
end

endmodule
