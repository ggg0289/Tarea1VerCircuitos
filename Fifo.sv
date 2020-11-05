/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                         Diseño del FIFO
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class fifo #(parameter pckg_sz = 32, parameter PROFUNDIDAD =10);
 //la profundidad de debe cambiar a random
   int Dispositivo;
   virtual fifo_if #(pckg_sz) vir_fifo;

   bit [pckg_sz-1:0] cola[$:PROFUNDIDAD]={};//si no sirve probar [pkt-1;0]cola[0][$:prof]
   task run();
      $display("[%g] El driver fue inicializado", $time);
      forever begin
	 @(posedge vir_fifo.clk or posedge vir_fifo.reset) 
	   begin
	      if (vir_fifo.reset) begin
		 cola={};
		 vir_fifo.pndng=0;
		 vir_fifo.full=0;	      
	      end // if (vir_fifo.reset)
	      
	      else if (vir_fifo.push && vir_fifo.pop) begin
		 if(cola.size==0) begin
		    $display("Se solicito un dato con el fifo vacio en el dispositivo:(push/pop) [%p]", Dispositivo);
		    cola.push_front(vir_fifo.D_push);
		    vir_fifo.pndng=1;	       
		 end // if (cola.size==0)	    
		 else begin
		    vir_fifo.D_pop=cola.pop_back();	  
		    cola.push_front(vir_fifo.D_push);
		    vir_fifo.pndng=1;	       
		 end // else: !if(cola.size==0)	    
	      end // if (vir_fifo.push && vir_fifo.pop)
	      
	      else if (vir_fifo.push)begin
		 if(cola.size==PROFUNDIDAD) begin
		    $display("Se intento agregar un dato a una fifo llena en el dispositivo: [%p]", Dispositivo);
		    vir_fifo.full=1;
		    vir_fifo.pndng=1;
		 end // if (cola.size=PROFUNDIDAD)
		 else begin
		    cola.push_front(vir_fifo.D_push);
		    vir_fifo.pndng=1;
		    if(cola.size==PROFUNDIDAD)
		      vir_fifo.full=1;
		 end // else: !if(cola.size=PROFUNDIDAD)
	      end // if (vir_fifo.push)
	      
	      else if (vir_fifo.pop) begin
		 if(cola.size==0) begin
		    $display("Se solicito un dato con el fifo vacio en el dispositivo:(push/pop) [%p]", Dispositivo);
		    vir_fifo.pndng=0;
		    vir_fifo.full=0;
		 end // if (cola.size==0)
		 
		 else begin
		    vir_fifo.D_pop=cola.pop_back();
		    vir_fifo.full=0;
		    if(cola.size==0)
		      vir_fifo.pndng=0;
		 end // else: !if(cola.size==0)
		 
	      end // if (vir_fifo.pop)	 
	      
	   end // @ (posedge vir_fifo.clk or posedge vir_fifo.reset)
	 
      end // forever begin
   endtask
endclass
