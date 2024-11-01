module alu 
  #(parameter NB_DATA = 6,   // Parámetro para la longitud del operando
                NB_OP = 6)     // Parámetro para la longitud del opcode
    (
    input  signed [NB_DATA-1:0] i_data_a,   // Primer operando 
    input  signed [NB_DATA-1:0] i_data_b,   // Segundo operando 
    input  [NB_OP-1:0] i_op,              // Código de operación
    output reg signed [NB_DATA:0] o_res // Salida
    );

    // Definición de los códigos de operación en un solo bloque
    localparam [NB_OP-1:0] 
        ADD     = 6'b100000,
        SUB     = 6'b100010,
        AND_OP  = 6'b100100,
        OR_OP   = 6'b100101,
        XOR_OP  = 6'b100110,
        NOR_OP  = 6'b100111,
        SRA     = 6'b000011, // Shift aritmético a la derecha
        SRL     = 6'b000010; // Shift lógico a la derecha

	always @(*) begin
        case (i_op)
            ADD:    o_res = i_data_a + i_data_b;      // Suma
            SUB:    o_res = i_data_a - i_data_b;      // Resta
            AND_OP: o_res = i_data_a & i_data_b;      // AND
            OR_OP:  o_res = i_data_a | i_data_b;      // OR
            XOR_OP: o_res = i_data_a ^ i_data_b;      // XOR
            NOR_OP: o_res = ~(i_data_a | i_data_b);   // NOR
            SRA:    o_res = i_data_a >>> i_data_b;    // Shift aritmético a la derecha
            SRL:    o_res = i_data_a >> i_data_b;     // Shift lógico a la derecha
            default: o_res = {{NB_DATA}{1'b0}};       // Valor por defecto -> 0
        endcase
    end
  
  // Copio el resultado de la operación en la salida
  //assign o_res = o_res;

endmodule