`timescale 1ns/1ps

module tb_alu;

    // ALU parameters
    parameter NB_DATA   = 6;   // Longitud de los operandos
    parameter NB_OP     = 6;   // Longitud del opcode

    reg [NB_OP-1:0] i_op;                  // Código de operación
    reg signed [NB_DATA-1:0] i_data_a;     // Primer operando
    reg signed [NB_DATA-1:0] i_data_b;     // Segundo operando
    wire signed [NB_DATA:0] o_data;        // Salida de la ALU (7 bits para manejar overflow)

    // Seed para generación aleatoria
    integer seed;

    // Instancia del módulo ALU
    alu #(
        .NB_DATA(NB_DATA),
        .NB_OP(NB_OP)
    ) uut (
        .i_data_a(i_data_a),
        .i_data_b(i_data_b),
        .i_op(i_op),
        .o_res(o_data)    // Salida ajustada al nombre correcto
    );

    // Tarea para realizar una operación ALU y mostrar los resultados
    task perform_test;
        input [NB_OP-1:0] op;
        input [NB_DATA-1:0] data_a;
        input [NB_DATA-1:0] data_b;
        begin
            i_data_a    = data_a;
            i_data_b    = data_b;
            i_op        = op;
            #10;  // Espera 10 unidades de tiempo para que se procese
            $display("%0t\t %b\t %b\t %b\t %b", $time, i_data_a, i_data_b, o_data, i_op);
        end
    endtask

    initial begin
        // Generar archivo VCD para ver las señales en GTKWave o similar
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_alu);

        seed = $random;

        // Comenzar simulación
        $display("Time\t A\t\t B\t\t Res\t\t OP");
        #10;

        // Casos de prueba
        perform_test(6'b100000, $random(seed), $random(seed));  // ADD
        perform_test(6'b100010, $random(seed), $random(seed));  // SUB
        perform_test(6'b100100, $random(seed), $random(seed));  // AND
        perform_test(6'b100101, $random(seed), $random(seed));  // OR
        perform_test(6'b100110, $random(seed), $random(seed));  // XOR
        perform_test(6'b000011, $random(seed), 6'd1);           // SRA (Shift aritmético a la derecha)
        perform_test(6'b000010, $random(seed), 6'd1);           // SRL (Shift lógico a la derecha)
        perform_test(6'b100111, $random(seed), $random(seed));  // NOR

        $finish;
    end

endmodule
