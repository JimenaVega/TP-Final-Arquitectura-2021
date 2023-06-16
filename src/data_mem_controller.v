`timescale 1ns / 1ps

module data_mem_controller#(
    parameter NB_DATA = 32
) 
(   
    input                   i_signed,
    input                   i_mem_write,
    input                   i_mem_read,
    input                   i_word_en,
    input                   i_halfword_en,
    input                   i_byte_en,

    input  [NB_DATA-1:0]    i_write_data,
    input  [NB_DATA-1:0]    i_read_data,

    output [NB_DATA-1:0]    o_write_data,
    output [NB_DATA-1:0]  	o_read_data
);

    reg [NB_DATA-1:0]   write_data;
    reg [NB_DATA-1:0]   read_data;

	always@(*) begin
        // Read
        if(i_mem_read)begin
            // Signed
            if(i_signed)begin
                case({i_word_en, i_halfword_en, i_byte_en})
                    3'b001:
                        read_data = {{24{i_read_data[7]}}, i_read_data[7:0]};
                    3'b010:
                        read_data = {{16{i_read_data[15]}}, i_read_data[15:0]};
                    3'b100:
                        read_data = i_read_data;

                    default:
                        read_data = 32'b0;
                endcase
            end
            // Unsigned
            else begin
                case({i_word_en, i_halfword_en, i_byte_en})
                    3'b001:
                        read_data = {{24'b0}, i_read_data[7:0]};
                    3'b010:
                        read_data = {{16'b0}, i_read_data[15:0]};
                    3'b100:
                        read_data = i_read_data;

                    default:
                        read_data = 32'b0;
                endcase
            end
        end
        else
            read_data = 32'b0;
        
        // Write
        if(i_mem_write)begin
            case({i_word_en, i_halfword_en, i_byte_en})
                3'b001:
                    write_data = i_read_data[7:0];
                3'b010:
                    write_data = i_read_data[15:0];
                3'b100:
                    write_data = i_read_data;

                default:
                    write_data = 32'b0;
            endcase
        end
        else
            write_data = 32'b0;
	end

    assign o_write_data = write_data;
	assign o_read_data  = read_data;

endmodule