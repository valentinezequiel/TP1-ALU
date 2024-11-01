module top
  #(parameter NB_DATA = 6,   // Tamaño de datos
                NB_OP = 6)    // Tamaño del código de operación
    (
    input  [NB_DATA-1:0] i_sw, // Entrada de los i_sw
    input  button1,                // Botón para cargar operando A
    input  button2,                // Botón para cargar operando B
    input  button3,                // Botón para cargar código de operación
    input  i_clk,                  // Reloj del sistema
    output wire [NB_DATA:0] o_led    // Visualización del resultado en LEDs
    );

    // Registros para almacenar los operandos y el código de operación
    reg [NB_DATA-1:0] i_data_a;
    reg [NB_DATA-1:0] i_data_b;
    reg [NB_OP-1:0] i_op;
    
    
    // Registro para almacenar el estado de los botones
    reg button1_r, button2_r, button3_r;

    // Instancia de la ALU
    alu #(.NB_DATA(NB_DATA), .NB_OP(NB_OP)) my_alu (
        .i_data_a(i_data_a),   // Conectamos data_a de top a la ALU
        .i_data_b(i_data_b),   // Conectamos data_b de top a la ALU
        .i_op(i_op),       // Conectamos i_op de top a la ALU
        .o_res(o_led)     // La salida de la ALU es el resultado que se visualizará
    );

    
    // Lógica para cargar valores en los registros de operandos y operación
    always @(posedge i_clk) begin
        // Registrar el estado actual de los botones
        button1_r <= button1;
        button2_r <= button2;
        button3_r <= button3;

        // Cargar i_sw en operando A si se presiona button1
        if (button1 && !button1_r) begin
            i_data_a <= i_sw;  
        end

        // Cargar i_sw en operando B si se presiona button2
        if (button2 && !button2_r) begin
            i_data_b <= i_sw;
        end

        // Cargar i_sw en código de operación si se presiona button3
        if (button3 && !button3_r) begin
            i_op <= i_sw;
        end

       
    end

endmodule