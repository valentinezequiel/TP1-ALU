**Universidad Nacional de Córdoba**

**Facultad de Ciencias Exactas, Físicas y Naturales**

# Arquitectura de Computadoras 2024
## Informe de Trabajo Práctico N°1: ALU en Basys 3


**Profesores:**
- Pereyra, Martin Miguel
- Rodriguez, Santiago
- Alonso, Martin

**Alumnos:**
- Badariotti, Juan Miguel (42.260.003)
- Ruiz, Valentin Ezequiel (42.692.393)
---

## 1. Introducción

El objetivo de este trabajo práctico es desarrollar una Unidad Aritmético-Lógica (ALU) utilizando una FPGA Basys 3. La ALU está diseñada para realizar operaciones aritméticas y lógicas básicas, con operandos y opcode parametrizables en longitud, lo que permite adaptar fácilmente el diseño a distintas necesidades de ancho de datos. Para controlar y observar su funcionamiento, se han asignado botones, switches y LEDs de la Basys 3 como entradas y salidas del sistema.

El proyecto incluye tres módulos principales:
- `top`: Módulo principal que conecta los periféricos de la FPGA a la ALU.
- `alu`: Módulo que define las operaciones de la ALU.
- `tb_alu`: Testbench para verificar el correcto funcionamiento de la ALU.

## 2. Definición de Constraints

En el archivo de constraints se define la configuración de los pines y la señal de reloj. Esto asegura que las señales lógicas y los dispositivos de la Basys 3 FPGA funcionen correctamente según el diseño.

### 2.1. Clock
- **Constraint utilizado:**
  ```verilog
  set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports { i_clk }];
  create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { i_clk }];
  ```
- **Descripción:**
  Configura el pin de reloj en `PACKAGE_PIN W5`, con un estándar de voltaje `LVCMOS33` y un periodo de 10 ns (frecuencia de 100 MHz).


### 2.2. Leds
- **Constraints utilizados:**
  ```verilog
  set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { o_led[0] }];
  set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports { o_led[1] }];
  set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports { o_led[2] }];
  set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports { o_led[3] }];
  set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports { o_led[4] }];
  set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports { o_led[5] }];
  set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { o_led[6] }];
  ```
- **Descripción:**
  Configura los pines de los LEDs `o_led[0]` a `o_led[6]` para mostrar el resultado de la ALU. Los LEDs restantes están comentados y no se usan en esta implementación.

### 2.3. Buttons
- **Constraints utilizados:**
  ```verilog
  set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports { button1 }];
  set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { button2 }];
  set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports { button3 }];
  ```
- **Descripción:**
  Los botones (`button1`, `button2`, `button3`) se usan para cargar los operandos y el código de operación (opcode) en la ALU, permitiendo cambiar dinámicamente estos valores.

### 2.4. Switches
- **Constraints utilizados:**
  ```verilog
  set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { i_sw[0] }];
  set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { i_sw[1] }];
  set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports { i_sw[2] }];
  set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports { i_sw[3] }];
  set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports { i_sw[4] }];
  set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { i_sw[5] }];
  ```
- **Descripción:**
  Los switches (`i_sw[0]` a `i_sw[5]`) permiten configurar los operandos y el opcode para la ALU. Los valores se cambian manualmente y se cargan en la ALU usando los botones.

## 3. Módulos Principales

### 3.1. Módulo `top`
   - **Entradas:**
     - `i_sw`: Switches que funcionan como entrada de operandos y opcode.
     - `button1`, `button2`, `button3`: Botones para cargar operandos y operación.
     - `i_clk`: Señal de reloj para sincronización.
   - **Salida:**
     - `o_led`: Representa la salida de la operación realizada por la ALU, visualizada en los LEDs de la Basys 3.

   - **Funcionalidad:**
     - Cada botón carga un valor específico:
       - `button1`: Carga `i_sw` en `i_data_a`.
       - `button2`: Carga `i_sw` en `i_data_b`.
       - `button3`: Carga `i_sw` en `i_op` (opcode).
     - La ALU recibe `i_data_a`, `i_data_b`, y `i_op` desde `top`, y el resultado (`o_res`) se visualiza en los LEDs (`o_led`).

### 3.2. Módulo `alu`
   - **Parámetros:**
     - `NB_DATA`: Define el ancho de los operandos.
     - `NB_OP`: Define el ancho del opcode.

   - **Entradas:**
     - `i_data_a`: Primer operando de la ALU.
     - `i_data_b`: Segundo operando de la ALU.
     - `i_op`: Código de operación.

   - **Salida:**
     - `o_res`: Resultado de la operación, se extiende un bit para manejar posibles overflow.

   - **Operaciones Definidas:**
     - **Aritméticas:**
       - `ADD 100000` Suma `i_data_a` + `i_data_b`.
       - `SUB 100010` Resta `i_data_a` - `i_data_b`.
     - **Lógicas:**
       - `AND 100100`: AND lógico entre `i_data_a` y `i_data_b`.
       - `OR 100101`: OR lógico entre `i_data_a` y `i_data_b`.
       - `XOR 100110`: XOR lógico entre `i_data_a` y `i_data_b`.
       - `NOR 100111`: NOR lógico entre `i_data_a` y `i_data_b`.
     - **Shift:**
       - `SRA 000011`: Desplazamiento aritmético de `i_data_a` hacia la derecha.
       - `SRL 000010`: Desplazamiento lógico de `i_data_a` hacia la derecha.

### 3.3. Testbench `tb_alu`
   - **Objetivo:**
     El módulo `tb_alu` realiza pruebas automatizadas sobre la ALU para verificar el correcto funcionamiento de sus operaciones.

   - **Tarea `perform_test`:**
     Permite realizar operaciones sobre la ALU y mostrar los resultados en consola usando `$display`. Cada prueba toma un opcode (`op`) y dos operandos (`data_a` y `data_b`), luego llama a la ALU y muestra los resultados.

   - **Casos de Prueba:**
     - Se prueban las operaciones aritméticas (`ADD`, `SUB`) y lógicas (`AND_OP`, `OR_OP`, `XOR_OP`, `NOR_OP`) con valores aleatorios generados por `$random`.
     - Para las operaciones de desplazamiento, el segundo operando (`data_b`) se fija en 1 para observar un desplazamiento unitario.

   - **Archivo de Simulación `dump.vcd`:**
     Genera un archivo de formato VCD (`Value Change Dump`) para que los resultados puedan analizarse visualmente en herramientas como GTKWave, donde se observan las transiciones de las señales.

## 4. Conclusión

Este proyecto implementa una ALU funcional y parametrizable en una FPGA Basys 3, capaz de realizar operaciones aritméticas y lógicas sin estar limitada a un tamaño específico de operandos o de opcode. En nuestro caso, definimos operandos de 6 bits y una salida de 7 bits para manejar posibles overflow, pero el diseño permite ajustar estos tamaños según sea necesario. Las pruebas realizadas con el testbench tb_alu confirman que la ALU responde correctamente a cada operación bajo condiciones simuladas. La implementación de constraints asegura una correcta asignación de los periféricos.

