`define PCKG_SZ 32 
`define DRVRS 4 
`define BITS 1
`define PROFUNDIDAD 10

`include "Fifo.sv"


interface fifo_if #(PCKG_SZ=32)(input clk);
   logic reset;
   logic pndng;
   logic push;
   logic pop;
   logic [PCKG_SZ-1:0] D_pop;
   logic [PCKG_SZ-1:0] D_push;   
endinterface // fifo_if



class Driver #(BITS=1,DRVRS=4, PCKG_SZ=32);
	   
   virtual bus_if #(BITS, DRVRS,PCKG_SZ) vir_bus_if;
   int 	   transacc;
   int 	   Drivers[DRVRS];
   
   virtual fifo_if #(PCKG_SZ) fif_if[DRVRS]; //creo las interfaces de los fifo
   fifo #(PCKG_SZ, `PROFUNDIDAD) ff[DRVRS];  //creo los fifos vacios
   
   
   task run();      
      $display("[%g] El driver fue inicializado", $time);
      @(posedge vir_bus_if.clk);   
      
      for (int i=0;i<DRVRS;i++) begin
	 ff[i]=new(); //instancio los fifos
	 //le asigno una interfaz virtual a la fifo
	 ff[i].vir_fifo.clk   = vir_bus_if.clk;
	 ff[i].vir_fifo.reset = vir_bus_if.reset;
	 ff[i].vir_fifo.pndng = vir_bus_if.pndng[0][i];
	 ff[i].vir_fifo.push  = vir_bus_if.push[0][i];
	 ff[i].vir_fifo.pop   = vir_bus_if.pop[0][i];
	 ff[i].vir_fifo.D_pop = vir_bus_if.D_pop[0][i];
	 ff[i].vir_fifo.D_push= vir_bus_if.D_push[0][i];
      end
      foreach(Drivers[i]) begin
	 fork
	    //aca se crearan los n fifo donde n es el numero de dispositivos,
	    //tambien podria agregar alguna funcion para controlarlos,//
	    //  tengo que ver como resultan las cosas 
	    ff[i].run();
	    $display ("[%0t ns] se inicializo el fifo para el dispositivo [%p]",$time, i);       	 join_none	   
      end      
      wait fork;
	 
	 $display ("Se finalizo la creacion de un fifo por cada bus", $time);
	 forever begin
	    $display("[%g] Esperando Transacción",$time);
	    //agent_mbx.get(transaccion);
	    transacc=0;
	 if(transacc==0) //
	   begin
	   end
	 else if(transacc==1) //
	   begin
	   end
	 else if(transacc==2) //
	   begin
	   end
	 else if(transacc==3) //
	   begin
	   end
	 else
	   $display("No se realizó una transacción valida");
	 
      end
   endtask // run
endclass // Driver




module test_driver;
   bit clk;
   always #1 clk<=~clk;
   //virtual bus_if #(`BITS, `DRVRS,`PCKG_SZ) vir_bus_if;
   bus_if uut_if(.clk(clk));
   
   Driver #(`BITS, `DRVRS, `PCKG_SZ) D1;
   
   
   
   initial begin
      D1=new();
      D1.vir_bus_if=uut_if;
      D1.run();
      
   end
   
endmodule // test_driver

interface bus_if #(BITS=1,DRVRS=4,PCKG_SZ=32)(input clk);
   logic reset;
   logic pndng[`BITS-1:0][`DRVRS-1:0];
   logic push[`BITS-1:0][`DRVRS-1:0];
   logic pop[`BITS-1:0][`DRVRS-1:0];
   logic [PCKG_SZ-1:0] D_pop[`BITS-1:0][`DRVRS-1:0];
   logic [PCKG_SZ-1:0] D_push[`BITS-1:0][`DRVRS-1:0];   
endinterface // bus_if
